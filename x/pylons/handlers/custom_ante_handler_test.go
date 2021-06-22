package handlers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/tx/signing"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// TestNewAccountCreationDecoratorAnteHandle is a test for NewAccountCreationDecorator handler
func TestNewAccountCreationDecoratorAnteHandle(t *testing.T) {

	tci := keeper.SetupTestCoinInput()
	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)
	acd := AccountCreationDecorator{tci.Ak}

	cases := map[string]struct {
		putSignature         bool
		shouldAccountExist   bool
		retryAccountCreation bool
		genNewAccount        bool
		desiredError         string
	}{
		"create_account no signature msg test": {
			putSignature:       false,
			shouldAccountExist: false,
			genNewAccount:      true,
		},
		"create_account for the address that does not exist": {
			putSignature:         true,
			shouldAccountExist:   true,
			genNewAccount:        true,
			retryAccountCreation: true,
		},
		"create_account wrong address of public key": {
			putSignature:       true,
			shouldAccountExist: false,
			genNewAccount:      false,
			desiredError:       "mismatch between signature pubkey and requester address",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			privKey, cosmosAddr, err := GenAccount()
			require.NoError(t, err)

			if tc.genNewAccount == false {
				cosmosAddr = sender1
			}

			txBuilder := tci.TxConfig.NewTxBuilder()
			msg := types.NewMsgCreateAccount(cosmosAddr.String())

			txBuilder.SetFeeAmount(sdk.NewCoins(sdk.NewInt64Coin("stake", 0)))
			txBuilder.SetMemo("")

			err = txBuilder.SetMsgs([]sdk.Msg{&msg}...)
			require.NoError(t, err)

			signMode := tci.TxConfig.SignModeHandler().DefaultMode()

			if tc.putSignature {
				var sigV2 signing.SignatureV2
				signerData := authsigning.SignerData{
					ChainID:       tci.Ctx.ChainID(),
					AccountNumber: 0,
					Sequence:      0,
				}
				// Generate the bytes to be signed.
				signBytes, err := tci.TxConfig.SignModeHandler().GetSignBytes(signMode, signerData, txBuilder.GetTx())
				require.NoError(t, err)

				// Sign those bytes
				signature, err := privKey.Sign(signBytes)
				require.NoError(t, err)

				// Construct the SignatureV2 struct
				sigData := signing.SingleSignatureData{
					SignMode:  signMode,
					Signature: signature,
				}

				sigV2 = signing.SignatureV2{
					PubKey:   privKey.PubKey(),
					Data:     &sigData,
					Sequence: 0,
				}

				err = txBuilder.SetSignatures(sigV2)
				require.NoError(t, err)
			}

			newCtx, err := acd.AnteHandle(tci.Ctx, txBuilder.GetTx(), false, emptyAnteHandle)
			if len(tc.desiredError) > 0 {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
				account := acd.ak.GetAccount(newCtx, cosmosAddr)
				if tc.shouldAccountExist {
					require.True(t, account != nil)
					require.True(t, account.GetSequence() == 0)
					if tc.retryAccountCreation {
						_, err = acd.AnteHandle(newCtx, txBuilder.GetTx(), false, emptyAnteHandle)
						require.True(t, strings.Contains(err.Error(), "account already exist"))
					}
				} else {
					require.True(t, account == nil)
				}
			}
		})
	}
}

// TestCustomSigVerificationDecoratorAnteHandle is a test for CustomSigVerificationDecorator handler
func TestCustomSigVerificationDecoratorAnteHandle(t *testing.T) {

	tci := keeper.SetupTestCoinInput()
	keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)
	csvd := CustomSigVerificationDecorator{tci.Ak, tci.TxConfig.SignModeHandler()}

	cases := map[string]struct {
		putSignature    bool
		accountNumber   uint64
		accountSequence uint64
		registerAccount bool
		additionMsgType string
		desiredError    string
	}{
		"create_account signature verification no signature msg test": {
			putSignature:    false,
			accountSequence: 0,
			desiredError:    "invalid number of signer;  expected: 1, got 0", // no signature error msg
		},
		"unknown address signature verification test": {
			putSignature:    true,
			accountNumber:   0,
			accountSequence: 0,
			desiredError:    "unknown address",
		},
		"create_account account_number=0, sequence=0 signature verification test": {
			putSignature:    true,
			registerAccount: true,
			accountNumber:   0,
			accountSequence: 0,
			additionMsgType: "create_cookbook",
		},
		"create_account account_number=1, sequence=0 signature verification test": {
			putSignature:    true,
			registerAccount: true,
			accountNumber:   1,
			accountSequence: 0,
			desiredError:    "create_account signature verification failed; verify correct account sequence and chain-id",
		},
		"create_account account_number=0, sequence=1 signature verification test": {
			putSignature:    true,
			registerAccount: true,
			accountNumber:   0,
			accountSequence: 1,
			desiredError:    "create_account signature verification failed; verify correct account sequence and chain-id",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			privKey, cosmosAddr, err := GenAccount()
			require.NoError(t, err)

			msg := types.NewMsgCreateAccount(cosmosAddr.String())

			txBuilder := tci.TxConfig.NewTxBuilder()

			txBuilder.SetFeeAmount(sdk.NewCoins(sdk.NewInt64Coin("stake", 0)))
			txBuilder.SetMemo("")

			err = txBuilder.SetMsgs([]sdk.Msg{&msg}...)
			require.NoError(t, err)

			signMode := tci.TxConfig.SignModeHandler().DefaultMode()

			if tc.putSignature {
				sigV2Empty := signing.SignatureV2{
					PubKey: privKey.PubKey(),
					Data: &signing.SingleSignatureData{
						SignMode:  tci.TxConfig.SignModeHandler().DefaultMode(),
						Signature: nil,
					},
					Sequence: 0,
				}
				err = txBuilder.SetSignatures(sigV2Empty)
				require.NoError(t, err)

				var sigV2 signing.SignatureV2
				signerData := authsigning.SignerData{
					ChainID:       tci.Ctx.ChainID(),
					AccountNumber: tc.accountNumber,
					Sequence:      tc.accountSequence,
				}
				// Generate the bytes to be signed.
				signBytes, err := tci.TxConfig.SignModeHandler().GetSignBytes(signMode, signerData, txBuilder.GetTx())
				require.NoError(t, err)

				// Sign those bytes
				signature, err := privKey.Sign(signBytes)
				require.NoError(t, err)

				// Construct the SignatureV2 struct
				sigData := signing.SingleSignatureData{
					SignMode:  signMode,
					Signature: signature,
				}

				sigV2 = signing.SignatureV2{
					PubKey:   privKey.PubKey(),
					Data:     &sigData,
					Sequence: tc.accountSequence,
				}

				err = txBuilder.SetSignatures(sigV2)
				require.True(t, err == nil)
			}

			if tc.registerAccount {
				any, err := codectypes.NewAnyWithValue(privKey.PubKey())
				require.True(t, err == nil)

				acc := &authtypes.BaseAccount{
					Sequence:      tc.accountSequence,
					AccountNumber: tci.Ak.GetNextAccountNumber(tci.Ctx),
					PubKey:        any,
					Address:       cosmosAddr.String(),
				}
				tci.Ak.SetAccount(tci.Ctx, acc)
			}

			_, err = csvd.AnteHandle(tci.Ctx, txBuilder.GetTx(), false, emptyAnteHandle)
			if len(tc.desiredError) > 0 {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
				if tc.additionMsgType == "create_cookbook" {
					caMsg := types.NewMsgCreateCookbook(
						"samecookbookID-0001",
						"samecookbookID-0001",
						"some description with 20 characters",
						"SketchyCo",
						"1.0.0",
						"example@example.com",
						0,
						types.DefaultCostPerBlock,
						cosmosAddr.String(),
					)
					txBuilder := tci.TxConfig.NewTxBuilder()

					txBuilder.SetFeeAmount(sdk.NewCoins(sdk.NewInt64Coin("stake", 0)))
					txBuilder.SetMemo("")

					err = txBuilder.SetMsgs([]sdk.Msg{&caMsg}...)
					require.NoError(t, err)

					signMode := tci.TxConfig.SignModeHandler().DefaultMode()
					sigV2Empty := signing.SignatureV2{
						PubKey: privKey.PubKey(),
						Data: &signing.SingleSignatureData{
							SignMode:  tci.TxConfig.SignModeHandler().DefaultMode(),
							Signature: nil,
						},
						Sequence: 0,
					}
					err = txBuilder.SetSignatures(sigV2Empty)
					require.NoError(t, err)

					var sigV2 signing.SignatureV2
					signerData := authsigning.SignerData{
						ChainID:       tci.Ctx.ChainID(),
						AccountNumber: tc.accountNumber,
						Sequence:      tc.accountSequence,
					}
					// Generate the bytes to be signed.
					signBytes, err := tci.TxConfig.SignModeHandler().GetSignBytes(signMode, signerData, txBuilder.GetTx())
					require.NoError(t, err)

					// Sign those bytes
					signature, err := privKey.Sign(signBytes)
					require.NoError(t, err)

					// Construct the SignatureV2 struct
					sigData := signing.SingleSignatureData{
						SignMode:  signMode,
						Signature: signature,
					}

					sigV2 = signing.SignatureV2{
						PubKey:   privKey.PubKey(),
						Data:     &sigData,
						Sequence: tc.accountSequence,
					}

					err = txBuilder.SetSignatures(sigV2)
					require.NoError(t, err)
					_, err = csvd.AnteHandle(tci.Ctx, txBuilder.GetTx(), false, emptyAnteHandle)
					require.NoError(t, err)
				}
			}
		})
	}
}

package handlers

import (
	"testing"
	"strings"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	authTypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	"github.com/stretchr/testify/require"
	"github.com/tyler-smith/go-bip39"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/crypto/keys/hd"
	"github.com/tendermint/tendermint/crypto/secp256k1"
)

const (
	mnemonicEntropySize = 256
)

// AnteHandle is a handler for NewAccountCreationDecorator
func emptyAnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool) (sdk.Context, error) {
	return ctx, nil
}

func genAccount(t *testing.T) (secp256k1.PrivKeySecp256k1, sdk.AccAddress) {
	entropySeed, err := bip39.NewEntropy(mnemonicEntropySize)
	require.True(t, err == nil)
	mnemonic, err := bip39.NewMnemonic(entropySeed)
	require.True(t, err == nil)

	// Generate a Bip32 HD wallet for the mnemonic and a user supplied password
	seed, err := bip39.NewSeedWithErrorChecking(mnemonic, "")
	require.True(t, err == nil)

	masterPriv, ch := hd.ComputeMastersFromSeed(seed)
	derivedPriv, err := hd.DerivePrivateKeyForPath(masterPriv, ch, "44'/118'/0'/0/0")
	require.True(t, err == nil)

	priv := secp256k1.PrivKeySecp256k1(derivedPriv)
	cosmosAddr := sdk.AccAddress(priv.PubKey().Address().Bytes())
	return priv, cosmosAddr
}

// TestNewAccountCreationDecoratorAnteHandle is a test for NewAccountCreationDecorator handler
func TestNewAccountCreationDecoratorAnteHandle(t *testing.T) {

	tci := keep.SetupTestCoinInput()
	sender1, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil)
	acd := AccountCreationDecorator{tci.Ak}

	cases := map[string]struct {
		putSignature bool
		shouldAccountExist bool
		retryAccountCreation bool
		genNewAccount bool
		desiredError  string
	}{
		"create_account no signature msg test": {
			putSignature: false,
			shouldAccountExist: false,
			genNewAccount: true,
		},
		"create_account for the address that does not exist": {
			putSignature: true,
			shouldAccountExist: true,
			genNewAccount: true,
			retryAccountCreation: true,
		},
		"create_account wrong address of public key": {
			putSignature: true,
			shouldAccountExist: false,
			genNewAccount: false,
			desiredError: "mismatch between signature pubkey and requester address",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			priv, cosmosAddr := genAccount(t)
			if tc.genNewAccount == false {
				cosmosAddr = sender1
			}

			fee := authTypes.NewStdFee(0, sdk.NewCoins(sdk.NewInt64Coin("stake", 0)))
			memo := ""
			tx := auth.NewStdTx([]sdk.Msg{msgs.NewMsgCreateAccount(cosmosAddr)}, fee, nil, memo)

			if tc.putSignature {
				sig, err := priv.Sign(auth.StdSignBytes("pylonschain", 0, 0, fee, tx.Msgs, memo))
				require.True(t, err == nil)
				sigs := []auth.StdSignature{
					{
						PubKey: priv.PubKey(),
						Signature: sig,
					},
				}
				tx.Signatures = sigs
			}
		
			newCtx, err := acd.AnteHandle(tci.Ctx, tx, false, emptyAnteHandle)
			if len(tc.desiredError) > 0 {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				account := acd.ak.GetAccount(newCtx, cosmosAddr)
				if tc.shouldAccountExist {
					require.True(t, account != nil)
					require.True(t, account.GetSequence() == 0)
					if tc.retryAccountCreation {
						newCtx, err = acd.AnteHandle(newCtx, tx, false, emptyAnteHandle)
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

	tci := keep.SetupTestCoinInput()
	keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil)
	csvd := CustomSigVerificationDecorator{tci.Ak}

	cases := map[string]struct {
		putSignature bool
		accountNumber uint64
		accountSequence uint64
		additionMsgType       string
		desiredError  string
	}{
		// "pubkey on account is not set": {

		// },
		// "unauthorized: invalid number of signer": {
		// 	putSignature: false,
		// 	accountNumber: 0,
		// 	accountSequence: 0,
		// 	desiredError: "unauthorized: invalid number of signer",
		// },
		"create_account signature verification no signature msg test": {
			putSignature: false,
			accountNumber: 0,
			accountSequence: 0,
			desiredError: "signature verification failed; verify correct account sequence and chain-id",
		},
		// "create_account account_number=0, sequence=0 signature verification test": {
		// 	putSignature: true,
		// 	accountNumber: 0,
		// 	accountSequence: 0,
		// 	desiredError: "signature verification failed; verify correct account sequence and chain-id",
		// },
		// "create_account account_number=1, sequence=0 signature verification test": {
		// 	putSignature: true,
		// 	accountNumber: 1,
		// 	accountSequence: 0,
		// 	desiredError: "signature verification failed; verify correct account sequence and chain-id",
		// },
		// "create_account account_number=0, sequence=1 signature verification test": {
		// 	putSignature: true,
		// 	accountNumber: 0,
		// 	accountSequence: 1,
		// 	desiredError: "signature verification failed; verify correct account sequence and chain-id",
		// },
		// "create_cookbook signature verification test": {
		// 	putSignature: true,
		// 	additionMsgType: "create_cookbook"
		// },
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			priv, cosmosAddr := genAccount(t)

			fee := authTypes.NewStdFee(0, sdk.NewCoins(sdk.NewInt64Coin("stake", 0)))
			memo := ""
			tx := auth.NewStdTx([]sdk.Msg{msgs.NewMsgCreateAccount(cosmosAddr)}, fee, nil, memo)

			if tc.putSignature {
				sig, err := priv.Sign(auth.StdSignBytes("pylonschain", tc.accountNumber, tc.accountSequence, fee, tx.Msgs, memo))
				require.True(t, err == nil)
				sigs := []auth.StdSignature{
					{
						PubKey: priv.PubKey(),
						Signature: sig,
					},
				}
				tx.Signatures = sigs
			}

			_, err := csvd.AnteHandle(tci.Ctx, tx, false, emptyAnteHandle)
			if len(tc.desiredError) > 0 {
				require.True(t, err != nil)
				t.Log("err.Error(), tc.desiredError", err.Error(), tc.desiredError)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				if tc.additionMsgType == "create_cookbook" {
					caMsg := msgs.NewMsgCreateCookbook("samecookbookID-0001", "samecookbookID-0001", "some description with 20 characters", "SketchyCo", "1.0.0", "example@example.com", 0, msgs.DefaultCostPerBlock, cosmosAddr)
					tx := auth.NewStdTx([]sdk.Msg{caMsg}, fee, nil, memo)
					sig, err := priv.Sign(auth.StdSignBytes("pylonschain", tc.accountNumber, tc.accountSequence, fee, tx.Msgs, memo))
					require.True(t, err == nil)
					sigs := []auth.StdSignature{
						{
							PubKey: priv.PubKey(),
							Signature: sig,
						},
					}
					tx.Signatures = sigs
					_, err = csvd.AnteHandle(tci.Ctx, tx, false, emptyAnteHandle)
					require.True(t, err == nil)
				}
			}
		})
	}
}

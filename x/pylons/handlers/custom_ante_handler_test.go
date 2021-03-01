package handlers
//
//import (
//	"strings"
//	"testing"
//
//	"github.com/Pylons-tech/pylons/x/pylons/keep"
//	"github.com/Pylons-tech/pylons/x/pylons/msgs"
//	"github.com/Pylons-tech/pylons/x/pylons/types"
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	"github.com/cosmos/cosmos-sdk/x/auth"
//	authTypes "github.com/cosmos/cosmos-sdk/x/auth/types"
//	"github.com/stretchr/testify/require"
//)
//
//// TestNewAccountCreationDecoratorAnteHandle is a test for NewAccountCreationDecorator handler
//func TestNewAccountCreationDecoratorAnteHandle(t *testing.T) {
//
//	tci := keep.SetupTestCoinInput()
//	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)
//	acd := AccountCreationDecorator{tci.Ak}
//
//	cases := map[string]struct {
//		putSignature         bool
//		shouldAccountExist   bool
//		retryAccountCreation bool
//		genNewAccount        bool
//		desiredError         string
//	}{
//		"create_account no signature msg test": {
//			putSignature:       false,
//			shouldAccountExist: false,
//			genNewAccount:      true,
//		},
//		"create_account for the address that does not exist": {
//			putSignature:         true,
//			shouldAccountExist:   true,
//			genNewAccount:        true,
//			retryAccountCreation: true,
//		},
//		"create_account wrong address of public key": {
//			putSignature:       true,
//			shouldAccountExist: false,
//			genNewAccount:      false,
//			desiredError:       "mismatch between signature pubkey and requester address",
//		},
//	}
//	for testName, tc := range cases {
//		t.Run(testName, func(t *testing.T) {
//			priv, cosmosAddr, err := GenAccount()
//			require.True(t, err == nil)
//
//			if tc.genNewAccount == false {
//				cosmosAddr = sender1
//			}
//
//			fee := authTypes.NewStdFee(0, sdk.NewCoins(sdk.NewInt64Coin("stake", 0)))
//			memo := ""
//			tx := auth.NewStdTx([]sdk.Msg{msgs.NewMsgCreateAccount(cosmosAddr)}, fee, nil, memo)
//
//			if tc.putSignature {
//				sig, err := priv.Sign(auth.StdSignBytes("pylonschain", 0, 0, fee, tx.Msgs, memo))
//				require.True(t, err == nil)
//				sigs := []auth.StdSignature{
//					{
//						PubKey:    priv.PubKey(),
//						Signature: sig,
//					},
//				}
//				tx.Signatures = sigs
//			}
//
//			newCtx, err := acd.AnteHandle(tci.Ctx, tx, false, emptyAnteHandle)
//			if len(tc.desiredError) > 0 {
//				require.True(t, err != nil)
//				require.True(t, strings.Contains(err.Error(), tc.desiredError))
//			} else {
//				require.True(t, err == nil)
//				account := acd.ak.GetAccount(newCtx, cosmosAddr)
//				if tc.shouldAccountExist {
//					require.True(t, account != nil)
//					require.True(t, account.GetSequence() == 0)
//					if tc.retryAccountCreation {
//						_, err = acd.AnteHandle(newCtx, tx, false, emptyAnteHandle)
//						require.True(t, strings.Contains(err.Error(), "account already exist"))
//					}
//				} else {
//					require.True(t, account == nil)
//				}
//			}
//		})
//	}
//}
//
//// TestCustomSigVerificationDecoratorAnteHandle is a test for CustomSigVerificationDecorator handler
//func TestCustomSigVerificationDecoratorAnteHandle(t *testing.T) {
//
//	tci := keep.SetupTestCoinInput()
//	keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)
//	csvd := CustomSigVerificationDecorator{tci.Ak}
//
//	cases := map[string]struct {
//		putSignature    bool
//		accountNumber   uint64
//		accountSequence uint64
//		registerAccount bool
//		additionMsgType string
//		desiredError    string
//	}{
//		"create_account signature verification no signature msg test": {
//			putSignature:    false,
//			accountSequence: 0,
//			desiredError:    "unauthorized: invalid number of signer;  expected: 1, got 0", // no signature error msg
//		},
//		"unknown address signature verification test": {
//			putSignature:    true,
//			accountNumber:   0,
//			accountSequence: 0,
//			desiredError:    "unknown address:",
//		},
//		"create_account account_number=0, sequence=0 signature verification test": {
//			putSignature:    true,
//			registerAccount: true,
//			accountNumber:   0,
//			accountSequence: 0,
//			additionMsgType: "create_cookbook",
//		},
//		"create_account account_number=1, sequence=0 signature verification test": {
//			putSignature:    true,
//			registerAccount: true,
//			accountNumber:   1,
//			accountSequence: 0,
//			desiredError:    "create_account signature verification failed; verify correct account sequence and chain-id",
//		},
//		"create_account account_number=0, sequence=1 signature verification test": {
//			putSignature:    true,
//			registerAccount: true,
//			accountNumber:   0,
//			accountSequence: 1,
//			desiredError:    "create_account signature verification failed; verify correct account sequence and chain-id",
//		},
//	}
//	for testName, tc := range cases {
//		t.Run(testName, func(t *testing.T) {
//			priv, cosmosAddr, err := GenAccount()
//			require.True(t, err == nil)
//
//			fee := authTypes.NewStdFee(0, sdk.NewCoins(sdk.NewInt64Coin("stake", 0)))
//			memo := ""
//			tx := auth.NewStdTx([]sdk.Msg{msgs.NewMsgCreateAccount(cosmosAddr)}, fee, nil, memo)
//
//			if tc.putSignature {
//				sig, err := priv.Sign(auth.StdSignBytes("pylonschain", tc.accountNumber, tc.accountSequence, fee, tx.Msgs, memo))
//				require.True(t, err == nil)
//				sigs := []auth.StdSignature{
//					{
//						PubKey:    priv.PubKey(),
//						Signature: sig,
//					},
//				}
//				tx.Signatures = sigs
//			}
//
//			if tc.registerAccount {
//				acc := &auth.BaseAccount{
//					Sequence:      0,
//					Coins:         sdk.Coins{},
//					AccountNumber: tci.Ak.GetNextAccountNumber(tci.Ctx),
//					PubKey:        priv.PubKey(),
//					Address:       cosmosAddr,
//				}
//				tci.Ak.SetAccount(tci.Ctx, acc)
//			}
//
//			_, err = csvd.AnteHandle(tci.Ctx, tx, false, emptyAnteHandle)
//			if len(tc.desiredError) > 0 {
//				require.True(t, err != nil)
//				require.True(t, strings.Contains(err.Error(), tc.desiredError))
//			} else {
//				require.True(t, err == nil)
//				if tc.additionMsgType == "create_cookbook" {
//					caMsg := msgs.NewMsgCreateCookbook("samecookbookID-0001", "samecookbookID-0001", "some description with 20 characters", "SketchyCo", "1.0.0", "example@example.com", 0, msgs.DefaultCostPerBlock, cosmosAddr)
//					tx := auth.NewStdTx([]sdk.Msg{caMsg}, fee, nil, memo)
//					sig, err := priv.Sign(auth.StdSignBytes("pylonschain", tc.accountNumber, tc.accountSequence, fee, tx.Msgs, memo))
//					require.True(t, err == nil)
//					sigs := []auth.StdSignature{
//						{
//							PubKey:    priv.PubKey(),
//							Signature: sig,
//						},
//					}
//					tx.Signatures = sigs
//					_, err = csvd.AnteHandle(tci.Ctx, tx, false, emptyAnteHandle)
//					require.True(t, err == nil)
//				}
//			}
//		})
//	}
//}

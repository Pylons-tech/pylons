package inttest

import (
	"fmt"
	"strings"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CoinLockTestCase struct {
	name      string
	extraInfo string

	hasInputItem   bool
	inputItemName  string
	wrongCBFulfill bool

	coinInputList types.CoinInputList

	hasOutputCoin    bool
	outputCoinName   string
	outputCoinAmount int64

	hasOutputItem  bool
	outputItemName string

	desiredError        string
	expectedStatus      string
	expectedMessage     string
	expectedRetryErrMsg string

	pylonsLLCDistribution int64
	cbOwnerDistribution   int64
	tradeCreatorDiff      int64
	tradeFulfillerDiff    int64
}

func TestCoinLockViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()
	tests := []CoinLockTestCase{
		{
			name:             "coin->coin fullfill trade test", // coin-coin fulfill trade test
			extraInfo:        "TESTTRD_FulfillTrade__001_TC1",
			hasInputItem:     false,
			coinInputList:    types.GenCoinInputList("node0token", 200),
			hasOutputCoin:    true,
			outputCoinName:   "pylon",
			outputCoinAmount: 100,
			hasOutputItem:    false,
			expectedStatus:   "Success",
			expectedMessage:  "successfully fulfilled the trade",
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			RunSingleCoinLockTestCase(tcNum, tc, t)
		})
	}
}

func RunSingleCoinLockTestCase(tcNum int, tc CoinLockTestCase, t *testing.T) {
	t.Parallel()

	cbOwnerKey := fmt.Sprintf("TestCoinLockViaCLI%d_CBOWNER_%d", tcNum, time.Now().Unix())
	MockAccount(cbOwnerKey, t) // mock account with initial balance

	mCB := GetMockedCookbook(cbOwnerKey, false, t)
	mCB2 := GetMockedCookbook(cbOwnerKey, true, t)

	tradeCreatorKey := fmt.Sprintf("TestCoinLockViaCLI%d_CREATOR_%d", tcNum, time.Now().Unix())
	MockAccount(tradeCreatorKey, t) // mock account with initial balance

	tradeCreatorAddr := inttestSDK.GetAccountAddr(tradeCreatorKey, t)
	tradeCreatorSdkAddress, err := sdk.AccAddressFromBech32(tradeCreatorAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")
	// tradeCreatorAccInfo := inttestSDK.GetAccountInfoFromAddr(tradeCreatorSdkAddress.String(), t)

	// lockedCoins, err := inttestSDK.ListLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	// t.MustNil(err, "error getting locked coins cli")

	// t.Log("\n\n\n ---------           Locked Coins for trade creator           --------- \n\n\n", lockedCoins.String())

	outputItemID := ""
	if tc.hasOutputItem {
		outputItemID = MockItemGUID(mCB.ID, tradeCreatorKey, tc.outputItemName, t)
	}

	// there should be no issues in mock process, for error checkers in create trade, it needs to be done at create_trade_test.go
	trdGUID := MockDetailedTradeGUID(
		tradeCreatorKey,
		mCB.ID,
		tc.coinInputList,
		tc.hasInputItem, tc.inputItemName,
		tc.hasOutputCoin, tc.outputCoinName, tc.outputCoinAmount,
		tc.hasOutputItem, outputItemID,
		fmt.Sprintf("%s%d", tc.extraInfo, time.Now().Unix()),
		t)

	t.MustTrue(trdGUID != "", "trade id shouldn't be empty after mock")

	lockedCoins, err := inttestSDK.ListLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	t.MustNil(err, "error getting locked coins cli")

	t.Log("\n\n\n ---------           Locked Coins after creating trade           --------- \n\n\n", lockedCoins.String())

	tradeFulfillerKey := fmt.Sprintf("TestCoinLockViaCLI%d_CREATOR_%d", tcNum, time.Now().Unix())
	MockAccount(tradeFulfillerKey, t) // mock account with initial balance
	if tc.coinInputList != nil {
		FaucetGameCoins(tradeFulfillerKey, tc.coinInputList.ToCoins(), t)
	}

	tradeFulfillerAddr := inttestSDK.GetAccountAddr(tradeFulfillerKey, t)
	tradeFulfillerSdkAddr, err := sdk.AccAddressFromBech32(tradeFulfillerAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")
	// tradeFulfillerAccInfo := inttestSDK.GetAccountInfoFromAddr(tradeFulfillerSdkAddr.String(), t)

	itemIDs := []string{}
	if len(tc.inputItemName) > 0 {
		useCBID := mCB.ID
		if tc.wrongCBFulfill {
			useCBID = mCB2.ID
		}
		itemIDs = []string{MockItemGUID(useCBID, tradeFulfillerKey, tc.inputItemName, t)}
	}

	ffTrdMsg := msgs.NewMsgFulfillTrade(trdGUID, tradeFulfillerSdkAddr, itemIDs)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, ffTrdMsg, tradeFulfillerKey, false)
	if err != nil {
		TxBroadcastErrorExpected(txhash, err, tc.desiredError, t)
		return
	}

	lockedCoins, err = inttestSDK.ListLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	t.MustNil(err, "error getting locked coins cli")

	t.Log("\n\n\n ---------           Locked Coins after fulfilling trade           --------- \n\n\n", lockedCoins.String())

	if tc.desiredError != "" {
		txHandleErrBytes := GetTxHandleError(txhash, t)
		t.WithFields(testing.Fields{
			"txhash":         txhash,
			"tx_error_bytes": string(txHandleErrBytes),
			"desired_error":  tc.desiredError,
		}).MustTrue(strings.Contains(string(txHandleErrBytes), tc.desiredError), "error is different from expected")
		return
	}

	txHandleResBytes := GetTxHandleResult(txhash, t)
	ffTrdResp := handlers.FulfillTradeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &ffTrdResp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	TxResultStatusMessageCheck(txhash, ffTrdResp.Status, ffTrdResp.Message, tc.expectedStatus, tc.expectedMessage, t)

	// Try again after fulfill trade
	// if tc.expectedRetryErrMsg != "" {
	// 	txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, ffTrdMsg, tradeFulfillerKey, false)
	// 	if err != nil {
	// 		TxBroadcastErrorCheck(txhash, err, t)
	// 		return
	// 	}

	// 	WaitOneBlockWithErrorCheck(t)

	// 	hmrErr := inttestSDK.GetHumanReadableErrorFromTxHash(txhash, t)
	// 	t.WithFields(testing.Fields{
	// 		"txhash":         txhash,
	// 		"hmrErr":         hmrErr,
	// 		"expectedHmrErr": tc.expectedRetryErrMsg,
	// 	}).MustTrue(strings.Contains(hmrErr, tc.expectedRetryErrMsg))
	// }
}

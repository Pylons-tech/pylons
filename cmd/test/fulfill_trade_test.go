package inttest

import (
	"fmt"
	"strings"
	originT "testing"
	"time"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type FulfillTradeTestCase struct {
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

	checkPylonDistribution bool
	pylonsLLCDistribution  int64
}

func TestFulfillTradeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()
	tests := []FulfillTradeTestCase{
		{
			name:                   "coin->coin fullfill trade test", // coin-coin fulfill trade test
			extraInfo:              "TESTTRD_FulfillTrade__001_TC1",
			hasInputItem:           false,
			coinInputList:          types.GenCoinInputList("node0token", 200),
			hasOutputCoin:          true,
			outputCoinName:         "pylon",
			outputCoinAmount:       100,
			hasOutputItem:          false,
			expectedStatus:         "Success",
			expectedMessage:        "successfully fulfilled the trade",
			expectedRetryErrMsg:    "this trade is already completed",
			checkPylonDistribution: true,
			pylonsLLCDistribution:  1,
		},
		{
			name:                   "item->coin fullfill trade test", // item-coin fulfill trade test
			extraInfo:              "TESTTRD_FulfillTrade__001_TC2",
			hasInputItem:           true,
			inputItemName:          "TESTITEM_FulfillTrade__001_TC2",
			coinInputList:          nil,
			hasOutputCoin:          true,
			outputCoinName:         "pylon",
			outputCoinAmount:       100,
			hasOutputItem:          false,
			expectedStatus:         "Success",
			expectedMessage:        "successfully fulfilled the trade",
			expectedRetryErrMsg:    "this trade is already completed",
			checkPylonDistribution: true,
			pylonsLLCDistribution:  1,
		},
		{
			name:                   "coin->item fullfill trade test", // coin-item fulfill trade test
			extraInfo:              "TESTTRD_FulfillTrade__001_TC3",
			hasInputItem:           false,
			coinInputList:          types.GenCoinInputList("pylon", 200),
			hasOutputCoin:          false,
			hasOutputItem:          true,
			outputItemName:         "TESTITEM_FulfillTrade__001_TC3",
			expectedStatus:         "Success",
			expectedMessage:        "successfully fulfilled the trade",
			expectedRetryErrMsg:    "this trade is already completed",
			checkPylonDistribution: true,
			pylonsLLCDistribution:  2,
		},
		{
			name:                   "item->item fullfill trade test", // item-item fulfill trade test
			extraInfo:              "TESTTRD_FulfillTrade__001_TC4",
			hasInputItem:           true,
			inputItemName:          "TESTITEM_FulfillTrade__001_TC4_INPUT",
			coinInputList:          types.GenCoinInputList("pylon", 200),
			hasOutputCoin:          false,
			hasOutputItem:          true,
			outputItemName:         "TESTITEM_FulfillTrade__001_TC4_OUTPUT",
			expectedStatus:         "Success",
			expectedMessage:        "successfully fulfilled the trade",
			expectedRetryErrMsg:    "this trade is already completed",
			checkPylonDistribution: true,
			pylonsLLCDistribution:  2,
		},
		{
			name:          "trade unordered coin input test",
			extraInfo:     "TESTTRD_FulfillTrade__001_TC5",
			hasInputItem:  true,
			inputItemName: "TESTITEM_FulfillTrade__001_TC5_INPUT",
			coinInputList: types.CoinInputList{
				types.CoinInput{Coin: "stake", Count: 100},
				types.CoinInput{Coin: "node0token", Count: 100},
			},
			hasOutputCoin:          true,
			outputCoinName:         "pylon",
			outputCoinAmount:       100,
			hasOutputItem:          false,
			expectedStatus:         "Success",
			expectedMessage:        "successfully fulfilled the trade",
			expectedRetryErrMsg:    "this trade is already completed",
			checkPylonDistribution: true,
			pylonsLLCDistribution:  1,
		},
		{
			name:             "same item with different cookbook id fulfill trade test",
			extraInfo:        "TESTTRD_FulfillTrade__001_TC6",
			hasInputItem:     true,
			inputItemName:    "TESTITEM_FulfillTrade__001_TC6_INPUT",
			wrongCBFulfill:   true,
			coinInputList:    nil,
			hasOutputCoin:    true,
			outputCoinName:   "pylon",
			outputCoinAmount: 100,
			hasOutputItem:    false,
			desiredError:     "the sender doesn't have the trade item attributes",
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			RunSingleFulfillTradeTestCase(tcNum, tc, t)
		})
	}
}

func RunSingleFulfillTradeTestCase(tcNum int, tc FulfillTradeTestCase, t *testing.T) {
	t.Parallel()
	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	t.MustNil(err, "error converting string address to AccAddress struct")
	pylonsLLCAccInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)

	cbOwnerKey := fmt.Sprintf("TestFulfillTradeViaCLI%d_CBOWNER_%d", tcNum, time.Now().Unix())
	MockAccount(cbOwnerKey, t) // mock account with initial balance

	mCB := GetMockedCookbook(cbOwnerKey, false, t)
	mCB2 := GetMockedCookbook(cbOwnerKey, true, t)

	tradeCreatorKey := fmt.Sprintf("TestFulfillTradeViaCLI%d_CREATOR_%d", tcNum, time.Now().Unix())
	MockAccount(tradeCreatorKey, t) // mock account with initial balance
	// FaucetGameCoins(tradeCreatorKey, tc.CoinOutputs, t)

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

	tradeFulfillerKey := fmt.Sprintf("TestFulfillTradeViaCLI%d_CREATOR_%d", tcNum, time.Now().Unix())
	MockAccount(tradeFulfillerKey, t) // mock account with initial balance
	if tc.coinInputList != nil {
		FaucetGameCoins(tradeFulfillerKey, tc.coinInputList.ToCoins(), t)
	}

	tradeFulfillerAddr := inttestSDK.GetAccountAddr(tradeFulfillerKey, t)
	tradeFulfillerSdkAddr, err := sdk.AccAddressFromBech32(tradeFulfillerAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

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
	if tc.expectedRetryErrMsg != "" {
		txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, ffTrdMsg, tradeFulfillerKey, false)
		if err != nil {
			TxBroadcastErrorCheck(txhash, err, t)
			return
		}

		WaitOneBlockWithErrorCheck(t)

		hmrErr := inttestSDK.GetHumanReadableErrorFromTxHash(txhash, t)
		t.WithFields(testing.Fields{
			"txhash":         txhash,
			"hmrErr":         hmrErr,
			"expectedHmrErr": tc.expectedRetryErrMsg,
		}).MustTrue(strings.Contains(hmrErr, tc.expectedRetryErrMsg))
	}

	if tc.checkPylonDistribution {
		accInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
		originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)
		pylonAvailOnLLC := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.pylonsLLCDistribution))
		t.MustTrue(pylonAvailOnLLC, "Pylons LLC should get correct revenue")
	}
}

package inttest

import (
	"fmt"
	"strings"
	originT "testing"
	"time"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdktypes "github.com/cosmos/cosmos-sdk/types"
	"github.com/gogo/protobuf/proto"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	Type "github.com/Pylons-tech/pylons_sdk/x/pylons/types"
)

type FulfillTradeTestCase struct {
	name      string
	extraInfo string

	hasInputItem   bool
	inputItemName  string
	wrongCBFulfill bool

	coinInputList    Type.CoinInputList
	tradeOutputCoins sdktypes.Coins

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

func TestFulfillTradeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()
	tests := []FulfillTradeTestCase{
		{
			name:                  "coin->coin fullfill trade test", // coin-coin fulfill trade test
			extraInfo:             "TESTTRD_FulfillTrade__001_TC1",
			hasInputItem:          false,
			coinInputList:         Type.GenCoinInputList("node0token", 200),
			tradeOutputCoins:      types.NewPylon(100),
			hasOutputItem:         false,
			expectedStatus:        "Success",
			expectedMessage:       "successfully fulfilled the trade",
			expectedRetryErrMsg:   "this trade is already completed",
			pylonsLLCDistribution: 10, // there's no item here and all the fee goes to pylons LLC
			tradeCreatorDiff:      -100,
			tradeFulfillerDiff:    90,
		},
		{
			name:                  "item->coin fullfill trade test", // item-coin fulfill trade test
			extraInfo:             "TESTTRD_FulfillTrade__001_TC2",
			hasInputItem:          true,
			inputItemName:         "TESTITEM_FulfillTrade__001_TC2",
			coinInputList:         nil,
			tradeOutputCoins:      types.NewPylon(100),
			hasOutputItem:         false,
			expectedStatus:        "Success",
			expectedMessage:       "successfully fulfilled the trade",
			expectedRetryErrMsg:   "this trade is already completed",
			pylonsLLCDistribution: 1,
			cbOwnerDistribution:   9,
			tradeCreatorDiff:      -100,
			tradeFulfillerDiff:    90,
		},
		{
			name:                  "coin->item fullfill trade test", // coin-item fulfill trade test
			extraInfo:             "TESTTRD_FulfillTrade__001_TC3",
			hasInputItem:          false,
			coinInputList:         Type.GenCoinInputList("pylon", 200),
			tradeOutputCoins:      nil,
			hasOutputItem:         true,
			outputItemName:        "TESTITEM_FulfillTrade__001_TC3",
			expectedStatus:        "Success",
			expectedMessage:       "successfully fulfilled the trade",
			expectedRetryErrMsg:   "this trade is already completed",
			pylonsLLCDistribution: 2,
			cbOwnerDistribution:   18,
			tradeCreatorDiff:      180,
			tradeFulfillerDiff:    -200,
		},
		{
			name:                  "item->item fullfill trade test", // item-item fulfill trade test
			extraInfo:             "TESTTRD_FulfillTrade__001_TC4",
			hasInputItem:          true,
			inputItemName:         "TESTITEM_FulfillTrade__001_TC4_INPUT",
			coinInputList:         Type.GenCoinInputList("pylon", 200),
			tradeOutputCoins:      nil,
			hasOutputItem:         true,
			outputItemName:        "TESTITEM_FulfillTrade__001_TC4_OUTPUT",
			expectedStatus:        "Success",
			expectedMessage:       "successfully fulfilled the trade",
			expectedRetryErrMsg:   "this trade is already completed",
			pylonsLLCDistribution: 2,
			cbOwnerDistribution:   18,
			tradeCreatorDiff:      180,
			tradeFulfillerDiff:    -200,
		},
		{
			name:          "trade unordered coin input test",
			extraInfo:     "TESTTRD_FulfillTrade__001_TC5",
			hasInputItem:  true,
			inputItemName: "TESTITEM_FulfillTrade__001_TC5_INPUT",
			coinInputList: Type.CoinInputList{
				{Coin: "stake", Count: 100},
				{Coin: "node0token", Count: 100},
			},
			tradeOutputCoins:      types.NewPylon(100),
			hasOutputItem:         false,
			expectedStatus:        "Success",
			expectedMessage:       "successfully fulfilled the trade",
			expectedRetryErrMsg:   "this trade is already completed",
			pylonsLLCDistribution: 1,
			cbOwnerDistribution:   9,
			tradeCreatorDiff:      -100,
			tradeFulfillerDiff:    90,
		},
		{
			name:             "same item with different cookbook id fulfill trade test",
			extraInfo:        "TESTTRD_FulfillTrade__001_TC6",
			hasInputItem:     true,
			inputItemName:    "TESTITEM_FulfillTrade__001_TC6_INPUT",
			wrongCBFulfill:   true,
			coinInputList:    nil,
			tradeOutputCoins: types.NewPylon(100),
			hasOutputItem:    false,
			desiredError:     "[0]th item does not match: cookbook id does not match",
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

	pylonsLLCAddress, pylonsLLCBalance := GetPylonsLLCAddressAndBalance(t)

	cbOwnerKey := fmt.Sprintf("TestFulfillTradeViaCLI%d_CBOwner_%d", tcNum, time.Now().Unix())
	tradeCreatorKey := fmt.Sprintf("TestFulfillTradeViaCLI%d_Creator_%d", tcNum, time.Now().Unix())
	tradeFulfillerKey := fmt.Sprintf("TestFulfillTradeViaCLI%d_Fulfiller_%d", tcNum, time.Now().Unix())
	MockAccount(cbOwnerKey, t)        // mock account with initial balance
	MockAccount(tradeCreatorKey, t)   // mock account with initial balance
	MockAccount(tradeFulfillerKey, t) // mock account with initial balance

	mCB := GetMockedCookbook(cbOwnerKey, false, t)
	mCB2 := GetMockedCookbook(cbOwnerKey, true, t)

	cbOwnerAddr := inttestSDK.GetAccountAddr(cbOwnerKey, t)
	tradeCreatorAddr := inttestSDK.GetAccountAddr(tradeCreatorKey, t)
	tradeFulfillerAddr := inttestSDK.GetAccountAddr(tradeFulfillerKey, t)
	cbOwnerAccInfo := inttestSDK.GetAccountBalanceFromAddr(cbOwnerAddr, t)
	tradeCreatorAccInfo := inttestSDK.GetAccountBalanceFromAddr(tradeCreatorAddr, t)
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
		tc.tradeOutputCoins,
		tc.hasOutputItem, outputItemID,
		fmt.Sprintf("%s%d", tc.extraInfo, time.Now().Unix()),
		t)

	t.MustTrue(trdGUID != "", "trade id shouldn't be empty after mock")

	if tc.coinInputList != nil {
		FaucetGameCoins(tradeFulfillerKey, tc.coinInputList.ToCoins(), t)
	}

	tradeFulfillerBalance := inttestSDK.GetAccountBalanceFromAddr(tradeFulfillerAddr, t)

	itemIDs := []string{}
	if len(tc.inputItemName) > 0 {
		useCBID := mCB.ID
		if tc.wrongCBFulfill {
			useCBID = mCB2.ID
		}
		itemIDs = []string{MockItemGUID(useCBID, tradeFulfillerKey, tc.inputItemName, t)}
	}

	ffTrdMsg := types.NewMsgFulfillTrade(trdGUID, tradeFulfillerBalance.Address, itemIDs, "pi_1DoShv2eZvKYlo2CqsROyFun", "pm_card_visa")
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &ffTrdMsg, tradeFulfillerKey, false)
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
	txMsgData := &sdktypes.TxMsgData{
		Data: make([]*sdktypes.MsgData, 0, 1),
	}
	err = proto.Unmarshal(txHandleResBytes, txMsgData)
	t.MustNil(err)
	t.MustTrue(len(txMsgData.Data) == 1, "number of msgs should be 1")
	t.MustTrue(txMsgData.Data[0].MsgType == (types.MsgFulfillTrade{}).Type(), "MsgType should be accurate")
	ffTrdResp := types.MsgFulfillTradeResponse{}
	err = proto.Unmarshal(txMsgData.Data[0].Data, &ffTrdResp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	TxResultStatusMessageCheck(txhash, ffTrdResp.Status, ffTrdResp.Message, tc.expectedStatus, tc.expectedMessage, t)

	// Try again after fulfill trade
	if tc.expectedRetryErrMsg != "" {
		txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, &ffTrdMsg, tradeFulfillerKey, false)
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

	if tc.pylonsLLCDistribution > 0 {
		accInfo := inttestSDK.GetAccountBalanceFromAddr(pylonsLLCAddress.String(), t)
		originPylonAmount := pylonsLLCBalance.Coins.AmountOf(types.Pylon)
		balanceOk := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.pylonsLLCDistribution))
		t.WithFields(testing.Fields{
			"pylons_llc_address":  pylonsLLCAddress.String(),
			"origin_amount":       originPylonAmount.Int64(),
			"target_distribution": tc.pylonsLLCDistribution,
			"actual_amount":       accInfo.Coins.AmountOf(types.Pylon).Int64(),
		}).Log(balanceOk, "Pylons LLC amount change")
		t.MustTrue(balanceOk, "Pylons LLC should get correct revenue")
	}

	if tc.cbOwnerDistribution > 0 {
		accInfo := inttestSDK.GetAccountBalanceFromAddr(cbOwnerAccInfo.Address, t)
		originPylonAmount := cbOwnerAccInfo.Coins.AmountOf(types.Pylon)
		balanceOk := accInfo.Coins.AmountOf(types.Pylon).Equal(sdktypes.NewInt(originPylonAmount.Int64() + tc.cbOwnerDistribution))
		t.WithFields(testing.Fields{
			"cbowner_key":         cbOwnerKey,
			"cbowner_address":     cbOwnerAccInfo.Address,
			"origin_amount":       originPylonAmount.Int64(),
			"target_distribution": tc.cbOwnerDistribution,
			"actual_amount":       accInfo.Coins.AmountOf(types.Pylon).Int64(),
		}).MustTrue(balanceOk, "cookbook owner should get correct revenue")
	}

	if tc.tradeCreatorDiff != 0 {
		accInfo := inttestSDK.GetAccountBalanceFromAddr(tradeCreatorAccInfo.Address, t)
		originPylonAmount := tradeCreatorAccInfo.Coins.AmountOf(types.Pylon)
		balanceOk := accInfo.Coins.AmountOf(types.Pylon).Equal(sdktypes.NewInt(originPylonAmount.Int64() + tc.tradeCreatorDiff))
		t.WithFields(testing.Fields{
			"creator_key":     tradeCreatorKey,
			"creator_address": tradeCreatorAccInfo.Address,
			"origin_amount":   originPylonAmount.Int64(),
			"target_change":   tc.tradeCreatorDiff,
			"actual_amount":   accInfo.Coins.AmountOf(types.Pylon).Int64(),
		}).MustTrue(balanceOk, "trade creator balance change should be correct")
	}

	if tc.tradeFulfillerDiff != 0 {
		accBalance := inttestSDK.GetAccountBalanceFromAddr(tradeFulfillerAddr, t)
		originPylonAmount := tradeFulfillerBalance.Coins.AmountOf(types.Pylon)
		balanceOk := accBalance.Coins.AmountOf(types.Pylon).Equal(sdktypes.NewInt(originPylonAmount.Int64() + tc.tradeFulfillerDiff))
		t.WithFields(testing.Fields{
			"fulfiller_key":     tradeFulfillerKey,
			"fulfiller_address": tradeFulfillerBalance.Address,
			"origin_amount":     originPylonAmount.Int64(),
			"target_change":     tc.tradeFulfillerDiff,
			"actual_amount":     accBalance.Coins.AmountOf(types.Pylon).Int64(),
		}).MustTrue(balanceOk, "trade fulfiller balance change should be correct")
	}
}

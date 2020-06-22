package inttest

import (
	"strings"
	originT "testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type FulfillTradeTestCase struct {
	name      string
	extraInfo string

	hasInputItem  bool
	inputItemName string

	coinInputList types.CoinInputList

	hasOutputCoin    bool
	outputCoinName   string
	outputCoinAmount int64

	hasOutputItem  bool
	outputItemName string

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
			pylonsLLCDistribution:  10,
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
			pylonsLLCDistribution:  10,
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
			pylonsLLCDistribution:  20,
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
			pylonsLLCDistribution:  20,
		},
		{
			name:                   "trade unordered coin input test", // item-item fulfill trade test
			extraInfo:              "TESTTRD_FulfillTrade__001_TC5",
			hasInputItem:           true,
			inputItemName:          "TESTITEM_FulfillTrade__001_TC5_INPUT",
			coinInputList:          types.CoinInputList{
				types.CoinInput{"aaaa",100},
				types.CoinInput{"zzzz",100},
				types.CoinInput{"cccc",100},
			},
			hasOutputCoin:          false,
			hasOutputItem:          true,
			outputItemName:         "TESTITEM_FulfillTrade__001_TC5_OUTPUT",
			expectedStatus:         "Success",
			expectedMessage:        "successfully fulfilled the trade",
			expectedRetryErrMsg:    "this trade is already completed",
			checkPylonDistribution: true,
			pylonsLLCDistribution:  20,
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
	t.MustNil(err)
	pylonsLLCAccInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)

	mCB := GetMockedCookbook(t)

	outputItemID := ""
	if tc.hasOutputItem {
		outputItemID = MockItemGUID(mCB.ID, tc.outputItemName, t)
	}

	trdGUID := MockDetailedTradeGUID(mCB.ID, 
		tc.coinInputList,
		tc.hasInputItem, tc.inputItemName,
		tc.hasOutputCoin, tc.outputCoinName, tc.outputCoinAmount,
		tc.hasOutputItem, outputItemID,
		tc.extraInfo,
		t)

	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	itemIDs := []string{}
	if len(tc.inputItemName) > 0 {
		itemIDs = []string{
			MockItemGUID(mCB.ID, tc.inputItemName, t),
		}
	}

	ffTrdMsg := msgs.NewMsgFulfillTrade(trdGUID, sdkAddr, itemIDs)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, ffTrdMsg, "eugen", false)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("unexpected transaction broadcast error")
		return
	}

	txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	ffTrdResp := handlers.FulfillTradeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &ffTrdResp)
	t.WithFields(testing.Fields{
		"txhash": txhash,
	}).MustNil(err)

	t.MustTrue(ffTrdResp.Status == tc.expectedStatus)
	t.MustTrue(ffTrdResp.Message == tc.expectedMessage)

	// Try again after fulfill trade
	txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, ffTrdMsg, "eugen", false)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("unexpected transaction broadcast error")
		return
	}

	err = inttestSDK.WaitForNextBlock()
	t.MustNil(err)
	hmrErr := inttestSDK.GetHumanReadableErrorFromTxHash(txhash, t)
	t.MustTrue(strings.Contains(hmrErr, tc.expectedRetryErrMsg))

	if tc.checkPylonDistribution {
		accInfo := inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
		originPylonAmount := pylonsLLCAccInfo.Coins.AmountOf(types.Pylon)
		pylonAvailOnLLC := accInfo.Coins.AmountOf(types.Pylon).GTE(sdk.NewInt(originPylonAmount.Int64() + tc.pylonsLLCDistribution))
		t.MustTrue(pylonAvailOnLLC)
	}
}

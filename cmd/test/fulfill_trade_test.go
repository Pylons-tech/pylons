package intTest

import (
	"strings"
	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type FulfillTradeTestCase struct {
	name      string
	extraInfo string

	hasInputItem  bool
	inputItemName string

	hasInputCoin    bool
	inputCoinName   string
	inputCoinAmount int64

	hasOutputCoin    bool
	outputCoinName   string
	outputCoinAmount int64

	hasOutputItem  bool
	outputItemName string

	expectedStatus      string
	expectedMessage     string
	expectedRetryErrMsg string
}

func TestFulfillTradeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	// t.Parallel()

	tests := []FulfillTradeTestCase{
		{
			"coin->coin fullfill trade test", // coin-coin fulfill trade test
			"TESTTRD_FulfillTrade__001_TC1",
			false,
			"",
			true,
			"eugencoin",
			200,
			true,
			"pylon",
			1,
			false,
			"",
			"Success",
			"successfully fulfilled the trade",
			"this trade is already completed",
		},
		{
			"item->coin fullfill trade test", // item-coin fulfill trade test
			"TESTTRD_FulfillTrade__001_TC2",
			true,
			"TESTITEM_FulfillTrade__001_TC2",
			false,
			"",
			0,
			true,
			"pylon",
			1,
			false,
			"",
			"Success",
			"successfully fulfilled the trade",
			"this trade is already completed",
		},
		{
			"coin->item fullfill trade test", // coin-item fulfill trade test
			"TESTTRD_FulfillTrade__001_TC3",
			false,
			"",
			true,
			"eugencoin",
			200,
			false,
			"",
			0,
			true,
			"TESTITEM_FulfillTrade__001_TC3",
			"Success",
			"successfully fulfilled the trade",
			"this trade is already completed",
		},
		{
			"item->item fullfill trade test", // item-item fulfill trade test
			"TESTTRD_FulfillTrade__001_TC4",
			true,
			"TESTITEM_FulfillTrade__001_TC4_INPUT",
			true,
			"eugencoin",
			200,
			false,
			"",
			0,
			true,
			"TESTITEM_FulfillTrade__001_TC4_OUTPUT",
			"Success",
			"successfully fulfilled the trade",
			"this trade is already completed",
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			RunSingleFulfillTradeTestCase(tcNum, tc, t)
		})
	}
}

func RunSingleFulfillTradeTestCase(tcNum int, tc FulfillTradeTestCase, t *testing.T) {
	// t.Parallel()

	outputItemID := ""
	if tc.hasOutputItem {
		outputItemID = MockItemGUID(tc.outputItemName, t)
	}

	trdGuid := MockDetailedTradeGUID(tc.hasInputCoin, tc.inputCoinName, tc.inputCoinAmount,
		tc.hasInputItem, tc.inputItemName,
		tc.hasOutputCoin, tc.outputCoinName, tc.outputCoinAmount,
		tc.hasOutputItem, outputItemID,
		tc.extraInfo,
		t)

	eugenAddr := GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	itemIDs := []string{}
	if len(tc.inputItemName) > 0 {
		itemIDs = []string{
			MockItemGUID(tc.inputItemName, t),
		}
	}

	ffTrdMsg := msgs.NewMsgFulfillTrade(trdGuid, sdkAddr, itemIDs)
	txhash := TestTxWithMsgWithNonce(t, ffTrdMsg, "eugen", false)

	txHandleResBytes, err := WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	ffTrdResp := handlers.FulfillTradeResp{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &ffTrdResp)
	t.MustNil(err)

	t.MustTrue(ffTrdResp.Status == tc.expectedStatus)
	t.MustTrue(ffTrdResp.Message == tc.expectedMessage)

	// Try again after fulfill trade
	txhash = TestTxWithMsgWithNonce(t, ffTrdMsg, "eugen", false)
	WaitForNextBlock()
	hmrErr := GetHumanReadableErrorFromTxHash(txhash, t)
	t.MustTrue(strings.Contains(hmrErr, tc.expectedRetryErrMsg))
}

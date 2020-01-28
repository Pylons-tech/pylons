package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type FulfillTradeTestCase struct {
	name      string
	extraInfo string

	hasInputCoin    bool
	inputCoinName   string
	inputCoinAmount int64

	hasOutputCoin    bool
	outputCoinName   string
	outputCoinAmount int64

	expectedStatus      string
	expectedMessage     string
	expectedRetryErrMsg string
}

func TestFulfillTradeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []FulfillTradeTestCase{
		{
			"coin->coin fullfill trade test", // coin-coin create trade test
			"TESTTRD_FulfillTrade_001",
			true,
			"eugencoin",
			200,
			true,
			"pylon",
			1,
			"Success",
			"successfully fulfilled the trade",
			"this trade is already completed",
		},
		// TODO enrich create trade test with more cases item-item, item-coin, coin-item
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			RunSingleFulfillTradeTestCase(tcNum, tc, t)
		})
	}
}

func RunSingleFulfillTradeTestCase(tcNum int, tc FulfillTradeTestCase, t *testing.T) {
	t.Parallel()

	itemIDs := []string{}
	// TODO for item as input trading, should create an item and change itemIDs

	trdGuid := MockCoin2CoinTradeGUID(tc.inputCoinName, tc.inputCoinAmount, tc.outputCoinName, tc.outputCoinAmount, tc.extraInfo, t)

	eugenAddr := GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	ffTrdMsg := msgs.NewMsgFulfillTrade(trdGuid, sdkAddr, itemIDs)
	txhash := TestTxWithMsgWithNonce(t, ffTrdMsg, "eugen", false)

	txHandleResBytes, err := WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	t.Log("FulfillTrade txhash=", txhash, string(txHandleResBytes))
	ffTrdResp := handlers.FulfillTradeResp{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &ffTrdResp)
	t.MustNil(err)

	t.MustTrue(ffTrdResp.Status == tc.expectedStatus)
	t.MustTrue(ffTrdResp.Message == tc.expectedMessage)

	// Try again after fulfill trade
	txhash = TestTxWithMsgWithNonce(t, ffTrdMsg, "eugen", false)
	WaitForNextBlock()
	t.Log("FulfillTrade again txhash=", txhash)
	hmrErr := GetHumanReadableErrorFromTxHash(txhash, t)
	t.MustTrue(hmrErr == tc.expectedRetryErrMsg)
}

package inttest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestCreateTradeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name         string
		outputPylon  int64
		extraInfo    string
		desiredError string
	}{
		{
			name:        "item->coin create trade test", // item to coin create trade test
			outputPylon: 1000,
			extraInfo:   "TESTTRD_CreateTrade_001",
		},
		{
			name:         "less than minimum amount pylon trade test",
			outputPylon:  1,
			extraInfo:    "TESTTRD_CreateTrade_002",
			desiredError: "there should be more than 10 amount of pylon per trade",
		},
		// For coin-coin, item-item, coin-item trading, it is implemented in fulfill trade test already.
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			mCB := GetMockedCookbook(t)

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")
			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateTrade(
					nil,
					types.GenTradeItemInputList(mCB.ID, []string{"Raichu"}),
					types.NewPylon(tc.outputPylon),
					nil,
					tc.extraInfo,
					sdkAddr),
				"eugen",
				false,
			)
			if err != nil {
				TxBroadcastErrorExpected(txhash, err, tc.desiredError, t)
				return
			}

			GetTxHandleResult(txhash, t)
			// check trade created after 1 block
			tradeID, exist, err := inttestSDK.GetTradeIDFromExtraInfo(tc.extraInfo)
			t.WithFields(testing.Fields{
				"extra_info": tc.extraInfo,
			}).MustNil(err, "error getting trade id from extra info")
			t.WithFields(testing.Fields{
				"extra_info": tc.extraInfo,
			}).MustTrue(exist, "trade should exist but not")
			t.MustTrue(len(tradeID) > 0, "trade id shouldn't be empty")
		})
	}
}

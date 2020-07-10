package inttest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestCreateTradeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []struct {
		name         string
		inputPylon   int64
		outputPylon  int64
		extraInfo    string
		desiredError string
	}{
		{
			name:        "item->coin create trade test", // item to coin create trade success test
			outputPylon: 1000,
			extraInfo:   "TESTTRD_CreateTrade_001",
		},
		{
			name:         "less than minimum amount pylon trade test", // handler validation
			outputPylon:  1,
			extraInfo:    "TESTTRD_CreateTrade_002",
			desiredError: "there should be more than 10 amount of pylon per trade",
		},
		{
			name:         "zero denom output test", // msg validate basic
			outputPylon:  0,
			extraInfo:    "TESTTRD_CreateTrade_003",
			desiredError: "there should be no 0 amount denom on outputs",
		},
		{
			name:        "coin->coin create trade test", // coin to coin create trade success test
			inputPylon:  1,
			outputPylon: 1000,
			extraInfo:   "TESTTRD_CreateTrade_001",
		},
		// TODO should add more msg level validation and create trade handler error checks
		// for coin-coin, item-item, coin-item trading, msg.
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			mCB := GetMockedCookbook("eugen", false, t)

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err, "error converting string address to AccAddress struct")
			var inputCoins types.CoinInputList
			if tc.inputPylon > 0 {
				inputCoins = types.GenCoinInputList("pylon", tc.inputPylon)
			} else {
				inputCoins = nil
			}

			txhash, err := inttestSDK.TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateTrade(
					inputCoins,
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

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
		name      string
		extraInfo string
	}{
		{
			"item->coin create trade test", // item to coin create trade test
			"TESTTRD_CreateTrade_001",
		},
		// For coin-coin, item-item, coin-item trading, it is implemented in fulfill trade test already.
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			mCB := GetMockedCookbook(t)

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			txhash := inttestSDK.TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateTrade(
					nil,
					types.GenTradeItemInputList(mCB.ID, []string{"Raichu"}),
					types.NewPylon(1000),
					nil,
					tc.extraInfo,
					sdkAddr),
				"eugen",
				false,
			)

			_, err = inttestSDK.WaitAndGetTxData(txhash, 3, t)
			if err != nil {
				t.WithFields(testing.Fields{
					"error": err,
				}).Fatal("error waiting for creating trade")
			}
			// check trade created after 1 block
			tradeID, exist, err := inttestSDK.GetTradeIDFromExtraInfo(tc.extraInfo)
			t.MustNil(err)
			t.MustTrue(exist)
			t.MustTrue(len(tradeID) > 0)
		})
	}
}

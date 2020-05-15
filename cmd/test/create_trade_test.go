package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestCreateTradeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)

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
			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateTrade(
					nil,
					types.GenItemInputList("Raichu"),
					types.NewPylon(1000),
					nil,
					tc.extraInfo,
					sdkAddr),
				"eugen",
				false,
			)

			err = WaitForNextBlock()
			ErrValidation(t, "error waiting for creating trade %+v", err)
			// check trade created after 1 block
			tradeID, exist, err := GetTradeIDFromExtraInfo(tc.extraInfo)
			t.MustNil(err)
			t.MustTrue(exist)
			t.MustTrue(len(tradeID) > 0)
		})
	}
}

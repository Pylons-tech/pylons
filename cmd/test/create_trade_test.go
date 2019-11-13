package intTest

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

func TestCreateTradeViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	tests := []struct {
		name    string
		rcpName string
	}{
		{
			"basic flow test",
			"TESTRCP_CreateTrade_001",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			require.True(t, err == nil)
			TestTxWithMsg(t,
				msgs.NewMsgCreateTrade(
					nil,
					types.GenItemInputList("Raichu"),
					types.NewPylon(1000),
					nil,
					"",
					sdkAddr),
				"eugen",
			)
			// TODO check response by txhash
		})
	}
}

package intTest

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

func TestCreateTradeViaCLI(t *testing.T) {
	t.Parallel()

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
			TestTxWithMsgWithNonce(t,
				msgs.NewMsgCreateTrade(
					nil,
					types.GenItemInputList("Raichu"),
					types.NewPylon(1000),
					nil,
					"",
					sdkAddr),
				"eugen",
				false,
			)
			// TODO check response by txhash
		})
	}
}

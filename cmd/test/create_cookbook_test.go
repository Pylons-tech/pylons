package intTest

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

func TestCreateCookbookViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	tests := []struct {
		name   string
		cbName string
	}{
		{
			"basic flow test",
			"TESTCB_CreateCookbook_001",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)

			require.True(t, err == nil)
			txhash := TestTxWithMsg(t, msgs.NewMsgCreateCookbook(
				tc.cbName,
				"this has to meet character limits lol",
				"SketchyCo",
				"1.0.0",
				"example@example.com",
				0,
				msgs.DefaultCostPerBlock,
				sdkAddr))

			err = WaitForNextBlock()
			ErrValidation(t, "error waiting for creating cookbook %+v", err)

			txHandleResBytes, err := GetTxData(txhash, t)
			require.True(t, err == nil)
			resp := handlers.CreateCBResponse{}
			err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			require.True(t, err == nil)
			require.True(t, resp.CookbookID != "")
		})
	}
}

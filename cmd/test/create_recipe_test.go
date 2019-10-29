package intTest

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

func TestCreateRecipeViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	tests := []struct {
		name    string
		rcpName string
	}{
		{
			"basic flow test",
			"TESTRCP_CreateRecipe_001",
		},
	}

	mCB, err := GetMockedCookbook(t)
	ErrValidation(t, "error getting mocked cookbook %+v", err)

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			require.True(t, err == nil)
			txhash := TestTxWithMsg(t,
				msgs.NewMsgCreateRecipe(
					tc.rcpName,
					mCB.ID,
					"this has to meet character limits lol",
					types.GenCoinInputList("wood", 5),
					types.GenItemInputList("Raichu"),
					types.GenEntries("chair", "Raichu"),
					0,
					sdkAddr))
			// TODO check response by txhash

			err = WaitForNextBlock()
			ErrValidation(t, "error waiting for creating recipe %+v", err)

			txHandleResBytes, err := GetTxDetail(txhash, t)
			require.True(t, err == nil)
			resp := handlers.CreateRecipeResponse{}
			err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			require.True(t, err == nil)
			require.True(t, resp.RecipeID != "")
		})
	}
}

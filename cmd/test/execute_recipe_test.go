package intTest

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestExecuteRecipeViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	tests := []struct {
		name            string
		rcpName         string
		itemIDs         []string
		desiredItemName string
	}{
		{
			"basic flow test",
			"TESTRCP_ExecuteRecipe_003",
			[]string{},
			"TESTITEM_ExecuteRecipe_003",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			guid, err := MockRecipeWithName(tc.rcpName, tc.desiredItemName, t)
			ErrValidation(t, "error mocking recipe %+v", err)

			rcp, err := GetRecipeByGUID(guid)
			require.True(t, err == nil)

			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			require.True(t, err == nil)
			TestTxWithMsg(
				t,
				msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs))

			WaitForNextBlock()
			items, err := ListItemsViaCLI()
			ErrValidation(t, "error listing items via cli ::: %+v", err)

			_, ok := FindItemFromArrayByName(items, tc.desiredItemName)
			require.True(t, ok)
		})
	}
}

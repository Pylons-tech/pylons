package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestExecuteRecipeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	// t.Parallel()

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
			guid, err := MockNoDelayItemGenRecipeGUID(tc.rcpName, tc.desiredItemName, t)
			ErrValidation(t, "error mocking recipe %+v", err)

			rcp, err := GetRecipeByGUID(guid)
			t.MustNil(err)

			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs),
				"eugen",
				false,
			)

			WaitForNextBlock()
			items, err := ListItemsViaCLI("")
			ErrValidation(t, "error listing items via cli ::: %+v", err)

			_, ok := FindItemFromArrayByName(items, tc.desiredItemName, false)
			t.MustTrue(ok)
		})
	}
}

package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	intTestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
)

func TestExecuteRecipeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

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
			intTestSDK.ErrValidation(t, "error mocking recipe %+v", err)

			rcp, err := intTestSDK.GetRecipeByGUID(guid)
			t.MustNil(err)

			eugenAddr := intTestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			txhash := intTestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs),
				"eugen",
				false,
			)

			_, err = intTestSDK.WaitAndGetTxData(txhash, 3, t)
			intTestSDK.ErrValidation(t, "error waiting for transaction %+v", err)
			// intTestSDK.WaitForNextBlock()
			items, err := intTestSDK.ListItemsViaCLI("")
			intTestSDK.ErrValidation(t, "error listing items via cli ::: %+v", err)

			_, ok := intTestSDK.FindItemFromArrayByName(items, tc.desiredItemName, false)
			t.MustTrue(ok)
		})
	}
}

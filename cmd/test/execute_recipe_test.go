package inttest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
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
			inttestSDK.ErrValidation(t, "error mocking recipe %+v", err)

			rcp, err := inttestSDK.GetRecipeByGUID(guid)
			t.MustNil(err)

			eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			t.MustNil(err)
			txhash := inttestSDK.TestTxWithMsgWithNonce(
				t,
				msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs),
				"eugen",
				false,
			)

			_, err = inttestSDK.WaitAndGetTxData(txhash, 3, t)
			inttestSDK.ErrValidation(t, "error waiting for transaction %+v", err)
			// inttestSDK.WaitForNextBlock()
			items, err := inttestSDK.ListItemsViaCLI("")
			inttestSDK.ErrValidation(t, "error listing items via cli ::: %+v", err)

			_, ok := inttestSDK.FindItemFromArrayByName(items, tc.desiredItemName, false)
			t.MustTrue(ok)
		})
	}
}

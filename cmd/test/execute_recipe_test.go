package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestExecuteRecipeViaCLI(t *testing.T) {
	WaitForNextBlock()
	err := MockCookbook(t)
	if err != nil {
		t.Errorf("error mocking cookbook %+v", err)
		t.Fatal(err)
	}

	tests := []struct {
		name            string
		rcpName         string
		itemIDs         []string
		desiredItemName string
	}{
		{
			"basic flow test",
			"TESTRCP_ExecuteRecipe_001",
			[]string{},
			"Zombie",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			err = MockRecipeWithName(tc.rcpName, t)
			if err != nil {
				t.Errorf("error mocking recipe %+v", err)
				t.Fatal(err)
			}

			recipes, err := TestQueryListRecipe(t)
			if err != nil {
				t.Errorf("error listing recipes %+v", err)
				t.Fatal(err)
			}
			require.True(t, err == nil)
			require.True(t, len(recipes) > 0)

			rcp, ok := FindRecipeFromArrayByName(recipes, tc.rcpName)
			if !ok {
				t.Errorf("error getting recipe with name %+v", tc.rcpName)
				t.Fatal()
			}

			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			require.True(t, err == nil)
			TestTxWithMsg(
				t,
				msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs),
				"pylons/ExecuteRecipe")

			WaitForNextBlock()
			items, err := ListItemsViaCLI(t)
			if err != nil {
				t.Errorf("error listing items via cli ::: %+v", err)
			}
			_, ok = FindItemFromArrayByName(items, tc.desiredItemName)
			require.True(t, ok)
		})
	}
}

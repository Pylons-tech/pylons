package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCheckExecutionViaCLI(t *testing.T) {
	var blockInterval int64
	blockInterval = 5

	err := MockCookbook(t)
	if err != nil {
		t.Errorf("error mocking cookbook %+v", err)
		t.Fatal(err)
	}
	err = MockDelayedExecutionRecipeWithName(blockInterval, "RCP_execute_002", t)
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

	tests := []struct {
		name            string
		rcpName         string
		itemIDs         []string
		desiredItemName string
		payToComplete   bool
	}{
		{
			"basic flow test",
			"RCP_execute_001",
			[]string{},
			"Zombie",
			false,
		},
		// TODO should add test case for check_execution before test
		// TODO should add test case for early_payment
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
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

			WaitForBlockInterval(blockInterval)

			// TODO should add cli command for GetExecutionsBySender
			TestTxWithMsg(
				t,
				// msgs.NewMsgCheckExecution(execID string, ptc bool, sender sdk.AccAddress),
				msgs.NewMsgCheckExecution(execID string, tc.payToComplete, sdkAddr),
				"pylons/ExecuteRecipe")

			WaitForNextBlock()

			// TODO here desiredItemName should be random - not specific text since by execute_recipe it is available already and can't do real check
			items, err := ListItemsViaCLI(t)
			if err != nil {
				t.Errorf("error listing items via cli ::: %+v", err)
			}
			_, ok = FindItemFromArrayByName(items, tc.desiredItemName)
			require.True(t, ok)
		})
	}
}

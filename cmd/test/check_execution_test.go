package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCheckExecutionViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	tests := []struct {
		name                 string
		rcpName              string
		blockInterval        int64
		itemIDs              []string
		desiredItemName      string
		payToComplete        bool
		waitForBlockInterval bool
	}{
		{
			"basic flow test",
			"TESTRCP_CheckExecution__002",
			2,
			[]string{},
			"TESTITEM_CheckExecution__002",
			false,
			true,
		},
		// {
		// 	// TODO should implement early payment test case : implement after modifying structure to create GUID earlier.
		// 	"early payment test",
		// 	"TESTRCP_CheckExecution__002",
		// 	2,
		// 	[]string{},
		// 	"TESTITEM_CheckExecution__002",
		// 	true,
		// 	false,
		// },
		// {
		// 	// TODO should implement check_execution before test : implement after modifying structure to create GUID earlier.
		// 	"early payment test",
		// 	"TESTRCP_CheckExecution__002",
		// 	2,
		// 	[]string{},
		// 	"TESTITEM_CheckExecution__002",
		// 	false,
		// 	false,
		// },
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			err := MockDelayedExecutionRecipeWithName(tc.blockInterval, tc.rcpName, tc.desiredItemName, t)
			ErrValidation(t, "error mocking recipe %+v", err)

			recipes, err := TestQueryListRecipe(t)
			ErrValidation(t, "error listing recipes %+v", err)

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
				msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs))

			WaitForBlockInterval(tc.blockInterval)

			executions, err := ListExecutionsViaCLI(t)
			ErrValidation(t, "error listing executions %+v", err)

			exec, ok := FindExecutionByRecipeID(executions, rcp.ID)
			if !ok {
				t.Errorf("error finding execution with recipeID :: %+v :: rcpID=\"%s\"", executions, rcp.ID)
				t.Fatal(err)
			}

			TestTxWithMsg(
				t,
				msgs.NewMsgCheckExecution(exec.ID, tc.payToComplete, sdkAddr),
			)

			WaitForNextBlock()

			// Here desiredItemName should be different across tests cases and across test files
			items, err := ListItemsViaCLI(t)
			ErrValidation(t, "error listing items via cli ::: %+v", err)

			_, ok = FindItemFromArrayByName(items, tc.desiredItemName)
			require.True(t, ok)
		})
	}
}

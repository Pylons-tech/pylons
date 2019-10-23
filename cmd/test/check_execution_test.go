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
			"TESTRCP_CheckExecution__0030",
			2,
			[]string{},
			"TESTITEM_CheckExecution__0030",
			false,
			true,
		},
		{
			"early payment test",
			"TESTRCP_CheckExecution__0031",
			2,
			[]string{},
			"TESTITEM_CheckExecution__0031",
			true,
			false,
		},
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
			guid, err := MockRecipeGUID(tc.blockInterval, tc.rcpName, tc.desiredItemName, t)
			ErrValidation(t, "error mocking recipe %+v", err)

			rcp, err := GetRecipeByGUID(guid)
			require.True(t, err == nil)

			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			require.True(t, err == nil)
			TestTxWithMsg(
				t,
				msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs))

			if tc.waitForBlockInterval {
				WaitForBlockInterval(tc.blockInterval)
			} else {
				WaitForNextBlock()
			}

			executions, err := ListExecutionsViaCLI(t)
			ErrValidation(t, "error listing executions %+v", err)

			// TODO should be able to get executions by predefined GUID
			exec, ok := FindExecutionByRecipeID(executions, rcp.ID)
			if !ok {
				t.Errorf("error finding execution with recipeID :: rcpID=\"%s\"", rcp.ID)
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

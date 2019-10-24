package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCheckExecutionViaCLI(t *testing.T) {

	tests := []struct {
		name                 string
		rcpName              string
		blockInterval        int64
		itemIDs              []string
		desiredItemName      string
		payToComplete        bool
		waitForBlockInterval bool
		shouldSuccess        bool
	}{
		{
			"basic flow test",
			"TESTRCP_CheckExecution__007_TC1",
			2,
			[]string{},
			"TESTITEM_CheckExecution__007_TC1",
			false,
			true,
			true,
		},
		{
			"early payment test",
			"TESTRCP_CheckExecution__007_TC2",
			2,
			[]string{},
			"TESTITEM_CheckExecution__007_TC2",
			true,
			false,
			true,
		},
		{
			"no wait direct check execution test",
			"TESTRCP_CheckExecution__007_TC3",
			2,
			[]string{},
			"TESTITEM_CheckExecution__007_TC3",
			false,
			false,
			false,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
			WaitForNextBlock()

			guid, err := MockRecipeGUID(tc.blockInterval, tc.rcpName, tc.desiredItemName, t)
			ErrValidation(t, "error mocking recipe %+v", err)

			rcp, err := GetRecipeByGUID(guid)
			require.True(t, err == nil)

			eugenAddr := GetAccountAddr("eugen", t)
			sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
			require.True(t, err == nil)

			execMsg := msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, tc.itemIDs)
			TestTxWithMsg(
				t,
				execMsg)

			if tc.waitForBlockInterval {
				WaitForBlockInterval(tc.blockInterval)
			} else {
				WaitForNextBlock()
			}

			TestTxWithMsg(
				t,
				msgs.NewMsgCheckExecution(execMsg.ExecID, tc.payToComplete, sdkAddr),
			)

			// TODO can work with WaitForNextBlock()? not WaitForBlockInterval(2)?
			WaitForNextBlock()

			// Here desiredItemName should be different across tests cases and across test files
			items, err := ListItemsViaCLI(t)
			ErrValidation(t, "error listing items via cli ::: %+v", err)

			_, ok := FindItemFromArrayByName(items, tc.desiredItemName)
			require.True(t, ok == tc.shouldSuccess)

			exec, err := GetExecutionByGUID(execMsg.ExecID)
			if err != nil {
				t.Errorf("error finding execution with ExecID :: ExecID=\"%s\" %+v", execMsg.ExecID, err)
				t.Fatal(err)
			}
			require.True(t, exec.Completed == tc.shouldSuccess)
		})
	}
}

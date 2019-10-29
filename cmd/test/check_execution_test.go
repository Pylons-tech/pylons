package intTest

import (
	"encoding/json"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
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
		expectedStatus       string
		expectedMessage      string
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
			"Success",
			"successfully completed the execution",
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
			"Success",
			"successfully paid to complete the execution",
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
			"Pending",
			"execution pending",
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
			txhash := TestTxWithMsg(t, execMsg)

			if tc.waitForBlockInterval {
				WaitForBlockInterval(tc.blockInterval)
			} else {
				WaitForNextBlock()
			}

			txHandleResBytes, err := GetTxDetail(txhash, t)
			require.True(t, err == nil)
			execResp := handlers.ExecuteRecipeResp{}
			err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &execResp)
			require.True(t, err == nil)
			schedule := handlers.ExecuteRecipeScheduleOutput{}
			err = json.Unmarshal(execResp.Output, &schedule)
			require.True(t, err == nil)

			txhash = TestTxWithMsg(
				t,
				msgs.NewMsgCheckExecution(schedule.ExecID, tc.payToComplete, sdkAddr),
			)

			WaitForNextBlock()

			txHandleResBytes, err = GetTxDetail(txhash, t)
			require.True(t, err == nil)
			resp := handlers.CheckExecutionResp{}
			err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			require.True(t, err == nil)
			require.True(t, resp.Status == tc.expectedStatus)
			require.True(t, resp.Message == tc.expectedMessage)

			// Here desiredItemName should be different across tests cases and across test files
			items, err := ListItemsViaCLI()
			ErrValidation(t, "error listing items via cli ::: %+v", err)

			_, ok := FindItemFromArrayByName(items, tc.desiredItemName)
			require.True(t, ok == tc.shouldSuccess)

			exec, err := GetExecutionByGUID(schedule.ExecID)
			if err != nil {
				t.Errorf("error finding execution with ExecID :: ExecID=\"%s\" %+v", schedule.ExecID, err)
				t.Fatal(err)
			}
			require.True(t, exec.Completed == tc.shouldSuccess)
		})
	}
}

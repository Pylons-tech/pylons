package intTest

import (
	"encoding/json"
	"strconv"

	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type TestCase struct {
	name                    string
	rcpType                 types.RecipeType
	blockInterval           int64
	currentItemName         string
	desiredItemName         string
	payToComplete           bool
	waitForBlockInterval    bool
	shouldSuccess           bool
	expectedStatus          string
	expectedMessage         string
	tryFinishedExecution    bool
	expectedRetryResMessage string
	expectedRetryResStatus  string
}

func TestCheckExecutionViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []TestCase{
		{
			"basic flow test",
			types.GENERATION,
			2,
			"",
			"TESTITEM_CheckExecution__007_TC1",
			false,
			true,
			true,
			"Success",
			"successfully completed the execution",
			false,
			"",
			"",
		},
		{
			"early payment test",
			types.GENERATION,
			2,
			"",
			"TESTITEM_CheckExecution__007_TC2",
			true,
			false,
			true,
			"Success",
			"successfully paid to complete the execution",
			true,
			"execution already completed",
			"Completed",
		},
		{
			"no wait direct check execution test",
			types.GENERATION,
			2,
			"",
			"TESTITEM_CheckExecution__007_TC3",
			false,
			false,
			false,
			"Pending",
			"execution pending",
			false,
			"",
			"",
		},
		{
			"item upgrade check execution test and OwnerRecipeID check",
			types.UPGRADE,
			2,
			"TESTITEM_CheckExecution__007_TC4_CUR",
			"TESTITEM_CheckExecution__007_TC4",
			false,
			false,
			false,
			"Pending",
			"execution pending",
			false,
			"",
			"",
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			RunSingleCheckExecutionTestCase(tcNum, tc, t)
		})
	}
}

func RunSingleCheckExecutionTestCase(tcNum int, tc TestCase, t *testing.T) {
	t.Parallel()

	itemIDs := []string{}
	if len(tc.currentItemName) > 0 { // when item input is set
		itemIDs = []string{
			MockItemGUID(tc.currentItemName, t),
		}
	}
	rcpName := "TESTRCP_CheckExecution__007_TC" + strconv.Itoa(tcNum)
	guid, err := MockRecipeGUID(tc.blockInterval, tc.rcpType, rcpName, tc.currentItemName, tc.desiredItemName, t)
	ErrValidation(t, "error mocking recipe %+v", err)

	rcp, err := GetRecipeByGUID(guid)
	t.MustNil(err)

	eugenAddr := GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	execMsg := msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, itemIDs)
	txhash := TestTxWithMsgWithNonce(t, execMsg, "eugen", false)

	if tc.waitForBlockInterval {
		WaitForBlockInterval(tc.blockInterval)
	} else {
		WaitForNextBlock()
	}

	txHandleResBytes, err := GetTxData(txhash, t)
	t.MustNil(err)
	execResp := handlers.ExecuteRecipeResp{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &execResp)
	t.MustNil(err)
	schedule := handlers.ExecuteRecipeScheduleOutput{}
	err = json.Unmarshal(execResp.Output, &schedule)
	t.MustNil(err)

	if len(tc.currentItemName) > 0 { // when item input is set
		items, err := ListItemsViaCLI("")
		ErrValidation(t, "error listing items via cli ::: %+v", err)

		item, ok := FindItemFromArrayByName(items, tc.currentItemName, true)
		t.MustTrue(ok)
		t.MustTrue(item.OwnerRecipeID == guid)
	}

	chkExecMsg := msgs.NewMsgCheckExecution(schedule.ExecID, tc.payToComplete, sdkAddr)
	txhash = TestTxWithMsgWithNonce(t, chkExecMsg, "eugen", false)

	WaitForNextBlock()

	txHandleResBytes, err = GetTxData(txhash, t)
	t.MustNil(err)
	resp := handlers.CheckExecutionResp{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)
	t.MustTrue(resp.Status == tc.expectedStatus)
	t.MustTrue(resp.Message == tc.expectedMessage)

	// Here desiredItemName should be different across tests cases and across test files
	items, err := ListItemsViaCLI("")
	ErrValidation(t, "error listing items via cli ::: %+v", err)

	_, ok := FindItemFromArrayByName(items, tc.desiredItemName, false)
	t.MustTrue(ok == tc.shouldSuccess)

	exec, err := GetExecutionByGUID(schedule.ExecID)
	if err != nil {
		t.Fatalf("error finding execution with ExecID :: ExecID=\"%s\" %+v", schedule.ExecID, err)
	}
	t.MustTrue(exec.Completed == tc.shouldSuccess)
	if tc.tryFinishedExecution {
		txhash = TestTxWithMsgWithNonce(t, chkExecMsg, "eugen", false)
		WaitForNextBlock()

		txHandleResBytes, err = GetTxData(txhash, t)
		t.MustNil(err)
		resp := handlers.CheckExecutionResp{}
		err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.MustNil(err)
		t.MustTrue(resp.Status == tc.expectedRetryResStatus)
		t.MustTrue(resp.Message == tc.expectedRetryResMessage)
		// This is automatically checking OwnerRecipeID lock status ;)
	}
}

package inttest

import (
	"encoding/json"
	"strconv"

	originT "testing"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CheckExecutionTestCase struct {
	name                    string
	isUpgrdRecipe           bool
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

	tests := []CheckExecutionTestCase{
		{
			name:                 "basic flow test",
			blockInterval:        2,
			currentItemName:      "",
			desiredItemName:      "TESTITEM_CheckExecution__007_TC1",
			payToComplete:        false,
			waitForBlockInterval: true,
			shouldSuccess:        true,
			expectedStatus:       "Success",
			expectedMessage:      "successfully completed the execution",
			tryFinishedExecution: false,
		},
		{
			name:                    "early payment test",
			blockInterval:           4,
			currentItemName:         "",
			desiredItemName:         "TESTITEM_CheckExecution__007_TC2",
			payToComplete:           true,
			waitForBlockInterval:    false,
			shouldSuccess:           true,
			expectedStatus:          "Success",
			expectedMessage:         "successfully paid to complete the execution",
			tryFinishedExecution:    true,
			expectedRetryResMessage: "execution already completed",
			expectedRetryResStatus:  "Completed",
		},
		{
			name:                 "no wait direct check execution test",
			blockInterval:        4,
			currentItemName:      "",
			desiredItemName:      "TESTITEM_CheckExecution__007_TC3",
			payToComplete:        false,
			waitForBlockInterval: false,
			shouldSuccess:        false,
			expectedStatus:       "Pending",
			expectedMessage:      "execution pending",
			tryFinishedExecution: false,
		},
		{
			name:                 "item upgrade check execution test and OwnerRecipeID check",
			isUpgrdRecipe:        true,
			blockInterval:        4,
			currentItemName:      "TESTITEM_CheckExecution__007_TC4_CUR",
			desiredItemName:      "TESTITEM_CheckExecution__007_TC4",
			payToComplete:        false,
			waitForBlockInterval: false,
			shouldSuccess:        false,
			expectedStatus:       "Pending",
			expectedMessage:      "execution pending",
			tryFinishedExecution: false,
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			RunSingleCheckExecutionTestCase(tcNum, tc, t)
		})
	}
}

func RunSingleCheckExecutionTestCase(tcNum int, tc CheckExecutionTestCase, t *testing.T) {
	t.Parallel()

	itemIDs := []string{}
	if len(tc.currentItemName) > 0 { // when item input is set
		itemIDs = []string{
			MockItemGUID(tc.currentItemName, t),
		}
	}
	rcpName := "TESTRCP_CheckExecution__007_TC" + strconv.Itoa(tcNum)

	guid, err := MockRecipeGUID(tc.blockInterval, tc.isUpgrdRecipe, rcpName, tc.currentItemName, tc.desiredItemName, t)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error mocking recipe")
	}

	rcp, err := inttestSDK.GetRecipeByGUID(guid)
	t.MustNil(err)

	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	execMsg := msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, itemIDs)

	txhash := inttestSDK.TestTxWithMsgWithNonce(t, execMsg, "eugen", false)

	if tc.waitForBlockInterval {
		err := inttestSDK.WaitForBlockInterval(tc.blockInterval)
		t.MustNil(err)
	} else {
		err := inttestSDK.WaitForNextBlock()
		t.MustNil(err)
	}

	txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	execResp := handlers.ExecuteRecipeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &execResp)
	t.MustNil(err)
	schedule := handlers.ExecuteRecipeScheduleOutput{}
	err = json.Unmarshal(execResp.Output, &schedule)
	t.MustNil(err)

	if len(tc.currentItemName) > 0 { // when item input is set
		items, err := inttestSDK.ListItemsViaCLI("")
		if err != nil {
			t.WithFields(testing.Fields{
				"error": err,
			}).Fatal("error listing items via cli")
		}

		item, ok := inttestSDK.FindItemFromArrayByName(items, tc.currentItemName, true)
		t.MustTrue(ok)
		t.MustTrue(item.OwnerRecipeID == guid)
	}

	chkExecMsg := msgs.NewMsgCheckExecution(schedule.ExecID, tc.payToComplete, sdkAddr)
	txhash = inttestSDK.TestTxWithMsgWithNonce(t, chkExecMsg, "eugen", false)

	txHandleResBytes, err = inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	resp := handlers.CheckExecutionResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)
	t.MustTrue(resp.Status == tc.expectedStatus)
	t.MustTrue(resp.Message == tc.expectedMessage)

	// Here desiredItemName should be different across tests cases and across test files
	items, err := inttestSDK.ListItemsViaCLI("")
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error listing items via cli")
	}

	_, ok := inttestSDK.FindItemFromArrayByName(items, tc.desiredItemName, false)
	t.MustTrue(ok == tc.shouldSuccess)

	exec, err := inttestSDK.GetExecutionByGUID(schedule.ExecID)
	if err != nil {
		t.Fatalf("error finding execution with ExecID :: ExecID=\"%s\" %+v", schedule.ExecID, err)
	}
	t.MustTrue(exec.Completed == tc.shouldSuccess)
	if tc.tryFinishedExecution {
		txhash = inttestSDK.TestTxWithMsgWithNonce(t, chkExecMsg, "eugen", false)
		err := inttestSDK.WaitForNextBlock()
		t.MustNil(err)

		txHandleResBytes, err = inttestSDK.WaitAndGetTxData(txhash, 3, t)
		t.MustNil(err)
		resp := handlers.CheckExecutionResponse{}
		err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.MustNil(err)
		t.MustTrue(resp.Status == tc.expectedRetryResStatus)
		t.MustTrue(resp.Message == tc.expectedRetryResMessage)
		// This is automatically checking OwnerRecipeID lock status ;)
	}
}

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
	mCB := GetMockedCookbook(t)

	itemIDs := []string{}
	if len(tc.currentItemName) > 0 { // when item input is set
		itemIDs = []string{
			MockItemGUID(mCB.ID, tc.currentItemName, t),
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
	t.WithFields(testing.Fields{
		"recipe_guid": guid,
	}).MustNil(err, "recipe with target guid does not exist")

	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

	execMsg := msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, itemIDs)

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, execMsg, "eugen", false)
	if err != nil {
		t.WithFields(testing.Fields{
			"txhash": txhash,
			"error":  err,
		}).Fatal("unexpected transaction broadcast error")
		return
	}

	if tc.waitForBlockInterval {
		err := inttestSDK.WaitForBlockInterval(tc.blockInterval)
		t.WithFields(testing.Fields{
			"txhash":         txhash,
			"block_interval": tc.blockInterval,
		}).MustNil(err, "error waiting for block interval")
	} else {
		err := inttestSDK.WaitForNextBlock()
		t.MustNil(err, "error waiting for next block")
	}

	txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"tx_result_bytes": string(txHandleResBytes),
	}).MustNil(err, "error geting transaction data")
	execResp := handlers.ExecuteRecipeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &execResp)
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"tx_result_bytes": string(txHandleResBytes),
	}).MustNil(err, "error unmarshaling tx response")
	schedule := handlers.ExecuteRecipeScheduleOutput{}
	err = json.Unmarshal(execResp.Output, &schedule)
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"schedule_output": string(execResp.Output),
	}).MustNil(err, "error unmarshaling schedule output")

	if len(tc.currentItemName) > 0 { // when item input is set
		items, err := inttestSDK.ListItemsViaCLI("")
		if err != nil {
			t.WithFields(testing.Fields{
				"error": err,
			}).Fatal("error listing items via cli")
		}

		item, ok := inttestSDK.FindItemFromArrayByName(items, tc.currentItemName, true)
		t.WithFields(testing.Fields{
			"item_name": tc.currentItemName,
		}).MustTrue(ok, "item id with specific name does not exist")
		t.WithFields(testing.Fields{
			"OwnerRecipeID": item.OwnerRecipeID,
			"recipe_guid":   guid,
		}).MustTrue(item.OwnerRecipeID == guid, "owner recipe id is different from expected")
	}

	chkExecMsg := msgs.NewMsgCheckExecution(schedule.ExecID, tc.payToComplete, sdkAddr)
	txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, chkExecMsg, "eugen", false)
	if err != nil {
		t.WithFields(testing.Fields{
			"txhash": txhash,
			"error":  err,
		}).Fatal("unexpected transaction broadcast error")
		return
	}

	txHandleResBytes, err = inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"tx_result_bytes": string(txHandleResBytes),
	}).MustNil(err, "error geting transaction data")
	resp := handlers.CheckExecutionResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"tx_result_bytes": string(txHandleResBytes),
	}).MustNil(err, "error unmarshaling transaction result")
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"original_status": resp.Status,
		"target_status":   tc.expectedStatus,
	}).MustTrue(resp.Status == tc.expectedStatus, "transaction result status is different from expected")
	t.WithFields(testing.Fields{
		"txhash":           txhash,
		"original_message": resp.Message,
		"target_message":   tc.expectedMessage,
	}).MustTrue(resp.Message == tc.expectedMessage, "transaction result message is different from expected")

	// Here desiredItemName should be different across tests cases and across test files
	items, err := inttestSDK.ListItemsViaCLI("")
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error listing items via cli")
	}

	_, ok := inttestSDK.FindItemFromArrayByName(items, tc.desiredItemName, false)
	t.WithFields(testing.Fields{
		"item_name":   tc.desiredItemName,
		"exist":       ok,
		"shouldExist": tc.shouldSuccess,
	}).MustTrue(ok == tc.shouldSuccess, "item exist status is different from expected")

	exec, err := inttestSDK.GetExecutionByGUID(schedule.ExecID)
	if err != nil {
		t.Fatalf("error finding execution with ExecID :: ExecID=\"%s\" %+v", schedule.ExecID, err)
	}
	t.WithFields(testing.Fields{
		"completed":       exec.Completed,
		"shouldCompleted": tc.shouldSuccess,
	}).MustTrue(exec.Completed == tc.shouldSuccess)
	if tc.tryFinishedExecution {
		txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, chkExecMsg, "eugen", false)
		if err != nil {
			t.WithFields(testing.Fields{
				"txhash": txhash,
				"error":  err,
			}).Fatal("unexpected transaction broadcast error")
			return
		}

		err := inttestSDK.WaitForNextBlock()
		t.MustNil(err, "error waiting for next block")

		txHandleResBytes, err = inttestSDK.WaitAndGetTxData(txhash, 3, t)
		t.WithFields(testing.Fields{
			"txhash":          txhash,
			"tx_result_bytes": string(txHandleResBytes),
		}).MustNil(err, "error geting transaction data")
		resp := handlers.CheckExecutionResponse{}
		err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.WithFields(testing.Fields{
			"txhash":          txhash,
			"tx_result_bytes": string(txHandleResBytes),
		}).MustNil(err, "error unmarshaling transaction result")
		t.WithFields(testing.Fields{
			"txhash":          txhash,
			"original_status": resp.Status,
			"target_status":   tc.expectedRetryResStatus,
		}).MustTrue(resp.Status == tc.expectedRetryResStatus, "transaction result status is different from expected")
		t.WithFields(testing.Fields{
			"txhash":           txhash,
			"original_message": resp.Message,
			"target_message":   tc.expectedRetryResMessage,
		}).MustTrue(resp.Message == tc.expectedRetryResMessage, "transaction result message is different from expected")
		// This is automatically checking OwnerRecipeID lock status ;)
	}
}

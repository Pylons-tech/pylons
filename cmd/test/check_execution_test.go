package inttest

import (
	"encoding/json"
	"fmt"
	"strconv"
	"time"

	originT "testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/gogo/protobuf/proto"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
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
	cbOwnerKey := fmt.Sprintf("TestCheckExecutionViaCLI%d_%d", tcNum, time.Now().Unix())
	MockAccount(cbOwnerKey, t) // mock account with initial balance
	mCB := GetMockedCookbook(cbOwnerKey, false, t)

	itemIDs := []string{}
	if len(tc.currentItemName) > 0 { // when item input is set
		itemIDs = []string{
			MockItemGUID(mCB.ID, cbOwnerKey, tc.currentItemName, t),
		}
	}
	rcpName := "TESTRCP_CheckExecution__007_TC" + strconv.Itoa(tcNum)

	guid := MockRecipeGUID(cbOwnerKey, tc.blockInterval, tc.isUpgrdRecipe, rcpName, tc.currentItemName, tc.desiredItemName, t)

	rcp, err := inttestSDK.GetRecipeByGUID(guid)
	t.WithFields(testing.Fields{
		"recipe_guid": guid,
	}).MustNil(err, "recipe with target guid does not exist")

	sdkAddr := GetSDKAddressFromKey(cbOwnerKey, t)
	execMsg := types.NewMsgExecuteRecipe(rcp.ID, sdkAddr.String(), itemIDs)

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &execMsg, cbOwnerKey, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return
	}

	if tc.waitForBlockInterval {
		err := inttestSDK.WaitForBlockInterval(tc.blockInterval)
		t.WithFields(testing.Fields{
			"txhash":         txhash,
			"block_interval": tc.blockInterval,
		}).MustNil(err, "error waiting for block interval")
	} else {
		WaitOneBlockWithErrorCheck(t)
	}

	txHandleResBytes := GetTxHandleResult(txhash, t)
	txMsgData := &sdk.TxMsgData{
		Data: make([]*sdk.MsgData, 0, 1),
	}
	err = proto.Unmarshal(txHandleResBytes, txMsgData)
	t.MustNil(err)
	t.MustTrue(len(txMsgData.Data) == 1, "number of msgs should be 1")
	t.MustTrue(txMsgData.Data[0].MsgType == (types.MsgExecuteRecipe{}).Type(), "MsgType should be accurate")
	execResp := types.MsgExecuteRecipeResponse{}
	err = proto.Unmarshal(txMsgData.Data[0].Data, &execResp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	schedule := handlers.ExecuteRecipeScheduleOutput{}
	err = json.Unmarshal(execResp.Output, &schedule)
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"schedule_output": string(execResp.Output),
	}).MustNil(err, "error unmarshaling schedule output")

	if len(tc.currentItemName) > 0 { // when item input is set
		items, err := inttestSDK.ListItemsViaCLI("")
		t.MustNil(err, "error listing items via cli")

		item, ok := inttestSDK.FindItemFromArrayByName(items, tc.currentItemName, true, false)
		t.WithFields(testing.Fields{
			"item_name": tc.currentItemName,
		}).MustTrue(ok, "item id with specific name does not exist")
		t.WithFields(testing.Fields{
			"OwnerRecipeID": item.OwnerRecipeID,
			"recipe_guid":   guid,
		}).MustTrue(item.OwnerRecipeID == guid, "owner recipe id is different from expected")
	}

	chkExecMsg := types.NewMsgCheckExecution(schedule.ExecID, tc.payToComplete, sdkAddr.String())
	txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, &chkExecMsg, cbOwnerKey, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return
	}

	txHandleResBytes = GetTxHandleResult(txhash, t)
	txMsgData = &sdk.TxMsgData{
		Data: make([]*sdk.MsgData, 0, 1),
	}
	err = proto.Unmarshal(txHandleResBytes, txMsgData)
	t.MustNil(err)
	t.MustTrue(len(txMsgData.Data) == 1, "number of msgs should be 1")
	t.MustTrue(txMsgData.Data[0].MsgType == (types.MsgCheckExecution{}).Type(), "MsgType should be accurate")
	resp := types.MsgCheckExecutionResponse{}
	err = proto.Unmarshal(txMsgData.Data[0].Data, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	TxResultStatusMessageCheck(txhash, resp.Status, resp.Message, tc.expectedStatus, tc.expectedMessage, t)

	// Here desiredItemName should be different across tests cases and across test files
	items, err := inttestSDK.ListItemsViaCLI("")
	t.MustNil(err, "error listing items via cli")

	_, ok := inttestSDK.FindItemFromArrayByName(items, tc.desiredItemName, false, false)
	t.WithFields(testing.Fields{
		"item_name":   tc.desiredItemName,
		"exist":       ok,
		"shouldExist": tc.shouldSuccess,
	}).MustTrue(ok == tc.shouldSuccess, "item exist status is different from expected")

	exec, err := inttestSDK.GetExecutionByGUID(schedule.ExecID)
	t.WithFields(testing.Fields{
		"exec_id": schedule.ExecID,
	}).MustNil(err, "error finding execution")
	t.WithFields(testing.Fields{
		"completed":       exec.Completed,
		"shouldCompleted": tc.shouldSuccess,
	}).MustTrue(exec.Completed == tc.shouldSuccess)
	if tc.tryFinishedExecution {
		txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, &chkExecMsg, cbOwnerKey, false)
		if err != nil {
			TxBroadcastErrorCheck(txhash, err, t)
			return
		}

		WaitOneBlockWithErrorCheck(t)

		txHandleResBytes = GetTxHandleResult(txhash, t)
		txMsgData := &sdk.TxMsgData{
			Data: make([]*sdk.MsgData, 0, 1),
		}
		err = proto.Unmarshal(txHandleResBytes, txMsgData)
		t.MustNil(err)
		t.MustTrue(len(txMsgData.Data) == 1, "number of msgs should be 1")
		t.MustTrue(txMsgData.Data[0].MsgType == (types.MsgCheckExecution{}).Type(), "MsgType should be accurate")
		resp := types.MsgCheckExecutionResponse{}
		err = proto.Unmarshal(txMsgData.Data[0].Data, &resp)
		TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
		TxResultStatusMessageCheck(txhash, resp.Status, resp.Message, tc.expectedRetryResStatus, tc.expectedRetryResMessage, t)
		// This is automatically checking OwnerRecipeID lock status ;)
	}
}

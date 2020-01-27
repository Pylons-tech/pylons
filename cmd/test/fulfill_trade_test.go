package intTest

import (
	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"
)

type FulfillTradeTestCase struct {
	name      string
	extraInfo string
}

func TestFulfillTradeViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []FulfillTradeTestCase{
		{
			"coin->coin fullfill trade test", // coin-coin create trade test
			"TESTTRD_FulfillTrade_001",
		},
		// TODO enrich create trade test with more cases item-item, item-coin, coin-item
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			RunSingleFulfillTradeTestCase(tcNum, tc, t)
		})
	}
}

func RunSingleFulfillTradeTestCase(tcNum int, tc FulfillTradeTestCase, t *testing.T) {
	t.Parallel()

	// eugenAddr := GetAccountAddr("eugen", t)
	// sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	// t.MustNil(err)
	// TestTxWithMsgWithNonce(t,
	// 	msgs.NewMsgCreateTrade(
	// 		nil,
	// 		types.GenItemInputList("Raichu"),
	// 		types.NewPylon(1000),
	// 		nil,
	// 		tc.extraInfo,
	// 		sdkAddr),
	// 	"eugen",
	// 	false,
	// )

	// err = WaitForNextBlock()
	// ErrValidation(t, "error waiting for creating trade %+v", err)
	// // check trade created after 1 block
	// tradeID, exist, err := GetTradeIDFromExtraInfo(tc.extraInfo)
	// t.MustNil(err)
	// t.MustTrue(exist)
	// t.MustTrue(len(tradeID) > 0)

	// CheckExecution code

	// itemIDs := []string{}
	// if len(tc.currentItemName) > 0 { // when item input is set
	// 	itemIDs = []string{
	// 		MockItemGUID(tc.currentItemName, t),
	// 	}
	// }
	// rcpName := "TESTRCP_CheckExecution__007_TC" + strconv.Itoa(tcNum)
	// guid, err := MockRecipeGUID(tc.blockInterval, tc.rcpType, rcpName, tc.currentItemName, tc.desiredItemName, t)
	// ErrValidation(t, "error mocking recipe %+v", err)

	// rcp, err := GetRecipeByGUID(guid)
	// t.MustNil(err)

	// eugenAddr := GetAccountAddr("eugen", t)
	// sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	// t.MustNil(err)

	// execMsg := msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, itemIDs)
	// txhash := TestTxWithMsgWithNonce(t, execMsg, "eugen", false)

	// if tc.waitForBlockInterval {
	// 	WaitForBlockInterval(tc.blockInterval)
	// } else {
	// 	WaitForNextBlock()
	// }

	// txHandleResBytes, err := GetTxData(txhash, t)
	// t.MustNil(err)
	// execResp := handlers.ExecuteRecipeResp{}
	// err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &execResp)
	// t.MustNil(err)
	// schedule := handlers.ExecuteRecipeScheduleOutput{}
	// err = json.Unmarshal(execResp.Output, &schedule)
	// t.MustNil(err)

	// if len(tc.currentItemName) > 0 { // when item input is set
	// 	items, err := ListItemsViaCLI("")
	// 	ErrValidation(t, "error listing items via cli ::: %+v", err)

	// 	item, ok := FindItemFromArrayByName(items, tc.currentItemName, true)
	// 	t.MustTrue(ok)
	// 	t.MustTrue(item.OwnerRecipeID == guid)
	// }

	// chkExecMsg := msgs.NewMsgCheckExecution(schedule.ExecID, tc.payToComplete, sdkAddr)
	// txhash = TestTxWithMsgWithNonce(t, chkExecMsg, "eugen", false)

	// WaitForNextBlock()

	// txHandleResBytes, err = GetTxData(txhash, t)
	// t.MustNil(err)
	// resp := handlers.CheckExecutionResp{}
	// err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	// t.MustNil(err)
	// t.MustTrue(resp.Status == tc.expectedStatus)
	// t.MustTrue(resp.Message == tc.expectedMessage)

	// // Here desiredItemName should be different across tests cases and across test files
	// items, err := ListItemsViaCLI("")
	// ErrValidation(t, "error listing items via cli ::: %+v", err)

	// _, ok := FindItemFromArrayByName(items, tc.desiredItemName, false)
	// t.MustTrue(ok == tc.shouldSuccess)

	// exec, err := GetExecutionByGUID(schedule.ExecID)
	// if err != nil {
	// 	t.Fatalf("error finding execution with ExecID :: ExecID=\"%s\" %+v", schedule.ExecID, err)
	// }
	// t.MustTrue(exec.Completed == tc.shouldSuccess)
	// if tc.tryFinishedExecution {
	// 	txhash = TestTxWithMsgWithNonce(t, chkExecMsg, "eugen", false)
	// 	WaitForNextBlock()

	// 	txHandleResBytes, err = GetTxData(txhash, t)
	// 	t.MustNil(err)
	// 	resp := handlers.CheckExecutionResp{}
	// 	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	// 	t.MustNil(err)
	// 	t.MustTrue(resp.Status == tc.expectedRetryResStatus)
	// 	t.MustTrue(resp.Message == tc.expectedRetryResMessage)
	// 	// This is automatically checking OwnerRecipeID lock status ;)
	// }
}

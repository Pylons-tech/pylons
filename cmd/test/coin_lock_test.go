package inttest

import (
	"encoding/json"
	"fmt"
	"strconv"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"
	"github.com/gogo/protobuf/proto"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CoinLockTestCase struct {
	name string

	tradeTest            bool
	tradeExtraInfo       string
	tradeCoinInputList   types.CoinInputList
	tradeOutputCoins     sdk.Coins
	tradeExpectedStatus  string
	tradeExpectedMessage string
	lockDiffTradeCreate  sdk.Coins
	lockDiffAfterFulfill sdk.Coins

	recipeTest                 bool
	recipeBlockInterval        int64
	currentItemName            string
	recipeDesiredItemName      string
	recipeWaitForBlockInterval bool
	recipeExpectedStatus       string
	recipeExpectedMessage      string
	lockDiffAfterSchedule      sdk.Coins
	lockDiffAfterCheckExec     sdk.Coins
}

func TestCoinLockViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()

	tests := []CoinLockTestCase{
		{
			name:                 "fullfill trade coin lock test",
			tradeTest:            true,
			tradeExtraInfo:       "TESTTRD_FulfillTrade__001_TC1",
			tradeCoinInputList:   types.GenCoinInputList("node0token", 200),
			tradeOutputCoins:     types.NewPylon(100),
			tradeExpectedStatus:  "Success",
			tradeExpectedMessage: "successfully fulfilled the trade",
			lockDiffTradeCreate:  types.NewPylon(100),
			lockDiffAfterFulfill: types.NewPylon(100),
		},
		{
			name:                       "check execution coin lock test",
			recipeTest:                 true,
			recipeBlockInterval:        3,
			recipeDesiredItemName:      "TESTITEM_CheckExecution__007_TC1",
			recipeWaitForBlockInterval: true,
			recipeExpectedStatus:       "Success",
			recipeExpectedMessage:      "successfully completed the execution",
			lockDiffAfterSchedule:      types.NewPylon(5),
			lockDiffAfterCheckExec:     types.NewPylon(5),
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			if tc.tradeTest {
				RunSingleTradeCoinLockTestCase(tcNum, tc, t)
			} else if tc.recipeTest {
				RunSingleCheckExecutionCoinLockTestCase(tcNum, tc, t)
			}
		})
	}
}

func RunSingleTradeCoinLockTestCase(tcNum int, tc CoinLockTestCase, t *testing.T) {
	t.Parallel()

	cbOwnerKey := fmt.Sprintf("TestCoinLockViaCLI%d_CBOwner_%d", tcNum, time.Now().Unix())
	tradeFulfillerKey := fmt.Sprintf("TestCoinLockViaCLI%d_Creator_%d", tcNum, time.Now().Unix())
	tradeCreatorKey := fmt.Sprintf("TestCoinLockViaCLI%d_Fulfiller_%d", tcNum, time.Now().Unix())
	MockAccount(cbOwnerKey, t)        // mock account with initial balance
	MockAccount(tradeFulfillerKey, t) // mock account with initial balance
	MockAccount(tradeCreatorKey, t)   // mock account with initial balance

	mCB := GetMockedCookbook(cbOwnerKey, false, t)

	tradeCreatorSdkAddress := GetSDKAddressFromKey(tradeCreatorKey, t)

	// check locked coin after fulfilling trade
	initialLock, err := inttestSDK.GetLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	t.MustNil(err, "error listing locked coins")

	// there should be no issues in mock process, for error checkers in create trade, it needs to be done at create_trade_test.go
	trdGUID := MockDetailedTradeGUID(
		tradeCreatorKey,
		mCB.ID,
		tc.tradeCoinInputList,
		false,
		"",
		tc.tradeOutputCoins,
		false,
		"",
		fmt.Sprintf("%s%d", tc.tradeExtraInfo, time.Now().Unix()),
		t)

	t.MustTrue(trdGUID != "", "trade id shouldn't be empty after mock")

	// check locked coin after fulfilling trade
	lockAfterCreateTrade, err := inttestSDK.GetLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	t.MustNil(err, "error listing locked coins")

	lcDiff := lockAfterCreateTrade.Amount.Sort().Sub(initialLock.Amount.Sort())
	t.WithFields(testing.Fields{
		"initial_lock":              initialLock.Amount,
		"lock_after_create_trade":   lockAfterCreateTrade.Amount,
		"desired_trade_create_lock": tc.lockDiffTradeCreate,
		"trade_creator_address":     tradeCreatorSdkAddress.String(),
	}).MustTrue(lcDiff.IsEqual(tc.lockDiffTradeCreate), "locked coin is invalid after creating trade")

	if tc.tradeCoinInputList != nil {
		FaucetGameCoins(tradeFulfillerKey, tc.tradeCoinInputList.ToCoins(), t)
	}

	tradeFulfillerSdkAddress := GetSDKAddressFromKey(tradeFulfillerKey, t)
	ffTrdMsg := types.NewMsgFulfillTrade(trdGUID, tradeFulfillerSdkAddress.String(), []string{})
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &ffTrdMsg, tradeFulfillerKey, false)

	t.MustNil(err, "error text tx with msg with nonce")

	txHandleResBytes := GetTxHandleResult(txhash, t)
	txMsgData := &sdk.TxMsgData{
		Data: make([]*sdk.MsgData, 0, 1),
	}
	err = proto.Unmarshal(txHandleResBytes, txMsgData)
	t.MustNil(err)
	t.MustTrue(len(txMsgData.Data) == 1, "number of msgs should be 1")
	t.MustTrue(txMsgData.Data[0].MsgType == (types.MsgFulfillTrade{}).Type(), "MsgType should be accurate")
	ffTrdResp := types.MsgFulfillTradeResponse{}
	err = proto.Unmarshal(txMsgData.Data[0].Data, &ffTrdResp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	TxResultStatusMessageCheck(txhash, ffTrdResp.Status, ffTrdResp.Message, tc.tradeExpectedStatus, tc.tradeExpectedMessage, t)

	// check locked coin after fulfilling trade
	lockAfterFulFillTrade, err := inttestSDK.GetLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	t.MustNil(err, "error listing locked coins")

	lcDiff = lockAfterCreateTrade.Amount.Sort().Sub(lockAfterFulFillTrade.Amount.Sort())
	t.WithFields(testing.Fields{
		"lock_after_create_trade":       lockAfterCreateTrade.Amount,
		"lock_after_fulfill_trade":      lockAfterFulFillTrade.Amount,
		"desired_lock_diff_for_fulfill": tc.lockDiffAfterFulfill,
		"trade_creator_address":         tradeCreatorSdkAddress.String(),
	}).MustTrue(lcDiff.IsEqual(tc.lockDiffAfterFulfill), "locked coin is invalid after creating trade")
}

func RunSingleCheckExecutionCoinLockTestCase(tcNum int, tc CoinLockTestCase, t *testing.T) {
	t.Parallel()

	cbOwnerKey := fmt.Sprintf("TestCheckExecutionCoinLockViaCLI_%d", time.Now().Unix())
	MockAccount(cbOwnerKey, t) // mock account with initial balance

	cbOwnerSdkAddr := GetSDKAddressFromKey(cbOwnerKey, t)

	rcpName := "TESTRCP_CheckExecutionCoinLock__007_TC" + strconv.Itoa(tcNum)

	guid := MockRecipeGUID(
		cbOwnerKey,
		tc.recipeBlockInterval,
		false,
		rcpName,
		tc.currentItemName,
		tc.recipeDesiredItemName,
		t,
	)

	rcp, err := inttestSDK.GetRecipeByGUID(guid)
	t.WithFields(testing.Fields{
		"recipe_guid": guid,
	}).MustNil(err, "recipe with target guid does not exist")

	execMsg := types.NewMsgExecuteRecipe(rcp.ID, cbOwnerSdkAddr.String(), []string{})

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &execMsg, cbOwnerKey, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return
	}

	initialLock, err := inttestSDK.GetLockedCoinsViaCLI(cbOwnerSdkAddr.String())
	t.MustNil(err, "error listing locked coins")

	if tc.recipeWaitForBlockInterval {
		err := inttestSDK.WaitForBlockInterval(tc.recipeBlockInterval)
		t.WithFields(testing.Fields{
			"txhash":         txhash,
			"block_interval": tc.recipeBlockInterval,
		}).MustNil(err, "error waiting for block interval")
	} else {
		WaitOneBlockWithErrorCheck(t)
	}

	lockAfterSchedule, err := inttestSDK.GetLockedCoinsViaCLI(cbOwnerSdkAddr.String())
	t.MustNil(err, "error listing locked coins")

	lcDiff := lockAfterSchedule.Amount.Sort().Sub(initialLock.Amount.Sort())
	t.WithFields(testing.Fields{
		"initial_lock":                   initialLock.Amount,
		"lock_after_schedule":            lockAfterSchedule.Amount,
		"desired_lock_diff_for_schedule": tc.lockDiffAfterSchedule,
		"cb_owner_address":               cbOwnerSdkAddr.String(),
	}).MustTrue(lcDiff.IsEqual(tc.lockDiffAfterSchedule), "locked coin is invalid after creating trade")

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

	chkExecMsg := types.NewMsgCheckExecution(schedule.ExecID, false, cbOwnerSdkAddr.String())

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
	TxResultStatusMessageCheck(txhash, resp.Status, resp.Message, tc.recipeExpectedStatus, tc.recipeExpectedMessage, t)

	// Here recipeDesiredItemName should be different across tests cases and across test files
	items, err := inttestSDK.ListItemsViaCLI("")
	t.MustNil(err, "error listing items via cli")

	_, ok := inttestSDK.FindItemFromArrayByName(items, tc.recipeDesiredItemName, false, false)
	t.WithFields(testing.Fields{
		"item_name":   tc.recipeDesiredItemName,
		"exist":       ok,
		"shouldExist": true,
	}).MustTrue(ok == true, "item exist status is different from expected")

	exec, err := inttestSDK.GetExecutionByGUID(schedule.ExecID)
	t.WithFields(testing.Fields{
		"exec_id": schedule.ExecID,
	}).MustNil(err, "error finding execution")
	t.WithFields(testing.Fields{
		"completed":       exec.Completed,
		"shouldCompleted": true,
	}).MustTrue(exec.Completed == true)

	lockAfterCheckExec, err := inttestSDK.GetLockedCoinsViaCLI(cbOwnerSdkAddr.String())
	t.MustNil(err, "error listing locked coins")

	lcDiff = lockAfterSchedule.Amount.Sort().Sub(lockAfterCheckExec.Amount.Sort())
	t.WithFields(testing.Fields{
		"lock_after_schedule":     lockAfterSchedule.Amount,
		"lock_after_check_exec":   lockAfterCheckExec.Amount,
		"desired_check_exec_lock": tc.lockDiffAfterCheckExec,
		"cb_owner_address":        cbOwnerSdkAddr.String(),
	}).MustTrue(lcDiff.IsEqual(tc.lockDiffAfterCheckExec), "locked coin is invalid after creating trade")
}

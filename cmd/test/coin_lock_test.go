package inttest

import (
	"encoding/json"
	"fmt"
	"strconv"
	originT "testing"
	"time"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CoinLockTestCase struct {
	name string

	tradeTest      bool
	tradeExtraInfo string

	tradeCoinInputList types.CoinInputList

	tradeOutputCoinName   string
	tradeOutputCoinAmount int64

	tradeExpectedStatus  string
	tradeExpectedMessage string

	tradeLockDifferAfterCreate sdk.Coins
	tradeLockDifferAfterTrade  sdk.Coins

	recipeTest bool

	recipeBlockInterval        int64
	currentItemName            string
	recipeDesiredItemName      string
	recipeWaitForBlockInterval bool
	recipeExpectedStatus       string
	recipeExpectedMessage      string

	recipeLockDifferAfterRecipe         sdk.Coins
	recipeLockDifferAfterCheckExecution sdk.Coins
}

func TestCoinLockViaCLI(originT *originT.T) {
	t := testing.NewT(originT)
	t.Parallel()
	tests := []CoinLockTestCase{
		{
			name: "fullfill trade coin lock test",

			tradeTest:      true,
			tradeExtraInfo: "TESTTRD_FulfillTrade__001_TC1",

			tradeCoinInputList: types.GenCoinInputList("node0token", 200),

			tradeOutputCoinName:   "pylon",
			tradeOutputCoinAmount: 100,

			tradeExpectedStatus:  "Success",
			tradeExpectedMessage: "successfully fulfilled the trade",

			tradeLockDifferAfterCreate: types.NewPylon(100),
			tradeLockDifferAfterTrade:  types.NewPylon(100),
		},
		{
			name: "check execution coin lock test",

			recipeTest:                 true,
			recipeBlockInterval:        2,
			recipeDesiredItemName:      "TESTITEM_CheckExecution__007_TC1",
			recipeWaitForBlockInterval: true,
			recipeExpectedStatus:       "Success",
			recipeExpectedMessage:      "successfully completed the execution",

			recipeLockDifferAfterRecipe:         types.NewPylon(5),
			recipeLockDifferAfterCheckExecution: types.NewPylon(5),
		},
	}

	for tcNum, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			if tc.tradeTest {
				RunSingleTradeCoinLockTestCase(tcNum, tc, t)
			}

			if tc.recipeTest {
				RunSingleCheckExecutionCoinLockTestCase(tcNum, tc, t)
			}
		})
	}
}

func RunSingleTradeCoinLockTestCase(tcNum int, tc CoinLockTestCase, t *testing.T) {

	cbOwnerKey := fmt.Sprintf("TestCoinLockViaCLI%d_CBOWNER_%d", tcNum, time.Now().Unix())
	MockAccount(cbOwnerKey, t) // mock account with initial balance

	mCB := GetMockedCookbook(cbOwnerKey, false, t)

	tradeCreatorKey := fmt.Sprintf("TestCoinLockViaCLI%d_CREATOR_%d", tcNum, time.Now().Unix())
	MockAccount(tradeCreatorKey, t) // mock account with initial balance

	tradeCreatorAddr := inttestSDK.GetAccountAddr(tradeCreatorKey, t)
	tradeCreatorSdkAddress, err := sdk.AccAddressFromBech32(tradeCreatorAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

	// check locked coin after fulfilling trade
	lockedCoinsFirst, err := inttestSDK.ListLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	t.MustNil(err, "error listing locked coins")

	// there should be no issues in mock process, for error checkers in create trade, it needs to be done at create_trade_test.go
	trdGUID := MockDetailedTradeGUID(
		tradeCreatorKey,
		mCB.ID,
		tc.tradeCoinInputList,
		false, "",
		true, tc.tradeOutputCoinName, tc.tradeOutputCoinAmount,
		false, "",
		fmt.Sprintf("%s%d", tc.tradeExtraInfo, time.Now().Unix()),
		t)

	t.MustTrue(trdGUID != "", "trade id shouldn't be empty after mock")

	// check locked coin after fulfilling trade
	lockedCoinsAfterCreateTrade, err := inttestSDK.ListLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	t.MustNil(err, "error listing locked coins")

	lcDiffer := lockedCoinsAfterCreateTrade.Amount.Sort().Sub(lockedCoinsFirst.Amount.Sort())
	t.MustTrue(lcDiffer.IsEqual(tc.tradeLockDifferAfterCreate), "locked coin is invalid after creating trade")

	tradeFulfillerKey := fmt.Sprintf("TestCoinLockViaCLI%d_CREATOR_%d", tcNum, time.Now().Unix())
	MockAccount(tradeFulfillerKey, t) // mock account with initial balance
	if tc.tradeCoinInputList != nil {
		FaucetGameCoins(tradeFulfillerKey, tc.tradeCoinInputList.ToCoins(), t)
	}

	tradeFulfillerAddr := inttestSDK.GetAccountAddr(tradeFulfillerKey, t)
	tradeFulfillerSdkAddr, err := sdk.AccAddressFromBech32(tradeFulfillerAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

	ffTrdMsg := msgs.NewMsgFulfillTrade(trdGUID, tradeFulfillerSdkAddr, []string{})
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, ffTrdMsg, tradeFulfillerKey, false)

	t.MustNil(err, "error text tx with msg with nonce")

	txHandleResBytes := GetTxHandleResult(txhash, t)
	ffTrdResp := handlers.FulfillTradeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &ffTrdResp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	TxResultStatusMessageCheck(txhash, ffTrdResp.Status, ffTrdResp.Message, tc.tradeExpectedStatus, tc.tradeExpectedMessage, t)

	// check locked coin after fulfilling trade
	lockedCoinsAfterFulFillTrade, err := inttestSDK.ListLockedCoinsViaCLI(tradeCreatorSdkAddress.String())
	t.MustNil(err, "error listing locked coins")

	lcDiffer = lockedCoinsAfterCreateTrade.Amount.Sort().Sub(lockedCoinsAfterFulFillTrade.Amount.Sort())
	t.MustTrue(lcDiffer.IsEqual(tc.tradeLockDifferAfterTrade), "locked coin is invalid after creating trade")
}

func RunSingleCheckExecutionCoinLockTestCase(tcNum int, tc CoinLockTestCase, t *testing.T) {
	cbOwnerKey := fmt.Sprintf("TestCheckExecutionCoinLockViaCLI%d_%d", tcNum, time.Now().Unix())
	MockAccount(cbOwnerKey, t) // mock account with initial balance

	rcpName := "TESTRCP_CheckExecutionCoinLock__007_TC" + strconv.Itoa(tcNum)

	guid, err := MockRecipeGUID(
		cbOwnerKey,
		tc.recipeBlockInterval,
		false,
		rcpName,
		tc.currentItemName,
		tc.recipeDesiredItemName,
		t,
	)

	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error mocking recipe")
	}

	rcp, err := inttestSDK.GetRecipeByGUID(guid)
	t.WithFields(testing.Fields{
		"recipe_guid": guid,
	}).MustNil(err, "recipe with target guid does not exist")

	cbOwnerAddr := inttestSDK.GetAccountAddr(cbOwnerKey, t)
	sdkAddr, err := sdk.AccAddressFromBech32(cbOwnerAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

	execMsg := msgs.NewMsgExecuteRecipe(rcp.ID, sdkAddr, []string{})

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, execMsg, cbOwnerKey, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return
	}

	lockedCoinsFirst, err := inttestSDK.ListLockedCoinsViaCLI(sdkAddr.String())
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

	lockedCoinsAfterRecipe, err := inttestSDK.ListLockedCoinsViaCLI(sdkAddr.String())
	t.MustNil(err, "error listing locked coins")

	lcDiffer := lockedCoinsAfterRecipe.Amount.Sort().Sub(lockedCoinsFirst.Amount.Sort())
	t.MustTrue(lcDiffer.IsEqual(tc.recipeLockDifferAfterRecipe), "locked coin is invalid after creating trade")

	txHandleResBytes := GetTxHandleResult(txhash, t)
	execResp := handlers.ExecuteRecipeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &execResp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	schedule := handlers.ExecuteRecipeScheduleOutput{}
	err = json.Unmarshal(execResp.Output, &schedule)
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"schedule_output": string(execResp.Output),
	}).MustNil(err, "error unmarshaling schedule output")

	chkExecMsg := msgs.NewMsgCheckExecution(schedule.ExecID, false, sdkAddr)

	txhash, err = inttestSDK.TestTxWithMsgWithNonce(t, chkExecMsg, cbOwnerKey, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return
	}

	txHandleResBytes = GetTxHandleResult(txhash, t)
	resp := handlers.CheckExecutionResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	TxResultStatusMessageCheck(txhash, resp.Status, resp.Message, tc.recipeExpectedStatus, tc.recipeExpectedMessage, t)

	// Here recipeDesiredItemName should be different across tests cases and across test files
	items, err := inttestSDK.ListItemsViaCLI("")
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error listing items via cli")
	}

	_, ok := inttestSDK.FindItemFromArrayByName(items, tc.recipeDesiredItemName, false, false)
	t.WithFields(testing.Fields{
		"item_name":   tc.recipeDesiredItemName,
		"exist":       ok,
		"shouldExist": true,
	}).MustTrue(ok == true, "item exist status is different from expected")

	exec, err := inttestSDK.GetExecutionByGUID(schedule.ExecID)
	if err != nil {
		t.WithFields(testing.Fields{
			"exec_id": schedule.ExecID,
			"error":   err,
		}).Fatal("error finding execution")
	}
	t.WithFields(testing.Fields{
		"completed":       exec.Completed,
		"shouldCompleted": true,
	}).MustTrue(exec.Completed == true)

	lockedCoinsAfterCheckExecution, err := inttestSDK.ListLockedCoinsViaCLI(sdkAddr.String())
	t.MustNil(err, "error listing locked coins")

	lcDiffer = lockedCoinsAfterRecipe.Amount.Sort().Sub(lockedCoinsAfterCheckExecution.Amount.Sort())
	t.MustTrue(lcDiffer.IsEqual(tc.recipeLockDifferAfterCheckExecution), "locked coin is invalid after creating trade")
}

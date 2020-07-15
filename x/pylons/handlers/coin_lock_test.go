package handlers

import (
	"encoding/json"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TestCoinLock is coin lock test
func TestCoinLock(t *testing.T) {
	tci := keep.SetupTestCoinInput()

	sender1, sender2, _, _ := keep.SetupTestAccounts(
		t,
		tci,
		sdk.Coins{
			sdk.NewInt64Coin("chair", 100000),
			sdk.NewInt64Coin(types.Pylon, 100000),
		},
		sdk.Coins{
			sdk.NewInt64Coin("chair", 100000),
			sdk.NewInt64Coin(types.Pylon, 100000),
		},
		nil, nil,
	)

	cbData := CreateCookbookResponse{}

	cookbookMsg := msgs.NewMsgCreateCookbook(
		"cookbook-0001",
		"",
		"this has to meet character limits",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		1,
		msgs.DefaultCostPerBlock,
		sender1,
	)

	cookbookResult, _ := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, cookbookMsg)
	err := json.Unmarshal(cookbookResult.Data, &cbData)
	require.True(t, err == nil)
	require.True(t, len(cbData.CookbookID) > 0)

	item1 := keep.GenItem(cbData.CookbookID, sender2, "Bhachu")
	err = tci.PlnK.SetItem(tci.Ctx, *item1)
	require.True(t, err == nil)

	cases := map[string]struct {
		// Create Trade Coin Lock Test
		testCreateTradeLock       bool
		testCreateTradeAmount     sdk.Coins
		testCreateTradeLockDiffer sdk.Coins
		// Execute Receipe Coin Lock Test
		testExecuteRecipeLock       bool
		testExecuteRecipeCoinInput  types.CoinInputList
		testExecuteRecipeLockDiffer sdk.Coins
		// Fulfill Trade Coin Unlock Test
		testFulfillTrade             bool
		testFulfillTradeInputItemIDs []string
		testFulfillTradeLockDiffer   sdk.Coins
		// Check Execution Coin Unlock Test
		testCheckExecution           bool
		testCheckExecutionLockDiffer sdk.Coins
		// Send Items Test
		testSendItems      bool
		testSendItemsError bool
		// Send Coins Test
		testSendCoins      bool
		testSendCoinsError bool
		// Execute Receipe Coin Unlock Test
		testSecondExecuteRecipe      bool
		testSecondExecuteRecipeError bool
	}{
		"create trade and fulfill trade coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testFulfillTrade:             true,
			testFulfillTradeInputItemIDs: []string{},
			testFulfillTradeLockDiffer:   types.NewPylon(100),
		},
		"create trade and send items coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testSendItems:      true,
			testSendItemsError: false,
		},
		"create trade and send coins coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testSendCoins:      true,
			testSendCoinsError: false,
		},
		"create trade and execute recipe coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testSecondExecuteRecipe:      true,
			testSecondExecuteRecipeError: false,
		},

		"execute recipe and check execution coin lock test": {
			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testCheckExecution:           true,
			testCheckExecutionLockDiffer: types.NewPylon(100),
		},
		"execute recipe and send items coin lock test": {
			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testSendItems:      true,
			testSendItemsError: false,
		},
		"execute recipe and send coins coin lock test": {
			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testSendCoins:      true,
			testSendCoinsError: false,
		},
		"execute recipe and execute recipe coin lock test": {
			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testSecondExecuteRecipe:      true,
			testSecondExecuteRecipeError: false,
		},

		"create trade & fulfill trade & execute recipe & check execution coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testFulfillTrade:             true,
			testFulfillTradeInputItemIDs: []string{},
			testFulfillTradeLockDiffer:   types.NewPylon(100),

			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testCheckExecution:           true,
			testCheckExecutionLockDiffer: types.NewPylon(100),
		},
		"create trade & fulfill trade & execute recipe & check execution and send items coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testFulfillTrade:             true,
			testFulfillTradeInputItemIDs: []string{},
			testFulfillTradeLockDiffer:   types.NewPylon(100),

			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testCheckExecution:           true,
			testCheckExecutionLockDiffer: types.NewPylon(100),

			testSendItems:      true,
			testSendItemsError: false,
		},
		"create trade & fulfill trade & execute recipe & check execution and send coins coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testFulfillTrade:             true,
			testFulfillTradeInputItemIDs: []string{},
			testFulfillTradeLockDiffer:   types.NewPylon(100),

			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testCheckExecution:           true,
			testCheckExecutionLockDiffer: types.NewPylon(100),

			testSendCoins:      true,
			testSendCoinsError: false,
		},
		"create trade & fulfill trade & execute recipe & check execution and execute recipe coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testFulfillTrade:             true,
			testFulfillTradeInputItemIDs: []string{},
			testFulfillTradeLockDiffer:   types.NewPylon(100),

			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testCheckExecution:           true,
			testCheckExecutionLockDiffer: types.NewPylon(100),

			testSecondExecuteRecipe:      true,
			testSecondExecuteRecipeError: false,
		},

		"create trade & execute recipe  coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),
		},
		"create trade & execute recipe and send items coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testSendItems:      true,
			testSendItemsError: false,
		},
		"create trade & execute recipe and send coins coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testSendCoins:      true,
			testSendCoinsError: false,
		},
		"create trade & execute recipe and execute recipe coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testExecuteRecipeLock:       true,
			testExecuteRecipeCoinInput:  types.GenCoinInputList("pylon", 100),
			testExecuteRecipeLockDiffer: types.NewPylon(100),

			testSecondExecuteRecipe:      true,
			testSecondExecuteRecipeError: false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			ctRespData := CreateTradeResponse{}
			scheduleOutput := ExecuteRecipeScheduleOutput{}

			// test create trade coin lock
			if tc.testCreateTradeLock {
				lcFirst, _ := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				ctRespData, err = MockTrade(
					tci,
					types.GenCoinInputList("chair", 100),
					types.TradeItemInputList{},
					types.NewPylon(100),
					types.ItemList{},
					sender1,
				)

				require.True(t, err == nil)

				lcAfterCreateTrade, err := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				require.True(t, err == nil)

				lcDiffer := lcAfterCreateTrade.Amount.Sort().Sub(lcFirst.Amount.Sort())

				require.True(t, lcDiffer.IsEqual(tc.testCreateTradeLockDiffer))

			}

			// test execute recipe coin lock
			if tc.testExecuteRecipeLock {
				lcFirst, _ := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				item := keep.GenItem(cbData.CookbookID, sender1, "Knife")
				err = tci.PlnK.SetItem(tci.Ctx, *item)
				require.True(t, err == nil)

				recipeData := MockRecipe(
					tci,
					"coin lock test recipe",
					tc.testExecuteRecipeCoinInput,
					types.GenItemInputList("Knife"),
					types.GenItemOnlyEntry("KnifeMRG"),
					types.GenOneOutput(1),
					cbData.CookbookID,
					2,
					sender1,
				)

				execRcpResponse, err := MockExecution(
					tci,
					recipeData.RecipeID,
					sender1,
					[]string{item.ID},
				)

				require.True(t, err == nil)
				require.True(t, execRcpResponse.Status == "Success")
				require.True(t, execRcpResponse.Message == "scheduled the recipe")

				err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
				require.True(t, err == nil)

				lcAfterExecRcp, _ := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				lcDiffer := lcAfterExecRcp.Amount.Sort().Sub(lcFirst.Amount.Sort())

				require.True(t, lcDiffer.IsEqual(tc.testExecuteRecipeLockDiffer))
			}

			// test send items after coin lock
			if tc.testSendItems {
				item := keep.GenItem(cbData.CookbookID, sender1, "sword")
				err = tci.PlnK.SetItem(tci.Ctx, *item)
				require.True(t, err == nil)

				msg := msgs.NewMsgSendItems([]string{item.ID}, sender1, sender2)
				_, err = HandlerMsgSendItems(tci.Ctx, tci.PlnK, msg)

				if !tc.testSendItemsError {
					require.True(t, err == nil)
				}
			}

			// test send coins after coin lock
			if tc.testSendCoins {
				err = keep.SendCoins(tci.PlnK, tci.Ctx, sender1, sender2, types.NewPylon(100))

				if !tc.testSendCoinsError {
					require.True(t, err == nil)
				}
			}

			// test execute recipe after coin lock
			if tc.testSecondExecuteRecipe {
				pylonInputRecipeData := MockRecipe(
					tci, "existing recipe",
					types.GenCoinInputList("pylon", 100),
					types.ItemInputList{},
					types.EntriesList{},
					types.WeightedOutputsList{},
					cbData.CookbookID,
					0,
					sender1,
				)

				msg := msgs.NewMsgExecuteRecipe(
					pylonInputRecipeData.RecipeID,
					sender1,
					[]string{},
				)
				_, err := HandlerMsgExecuteRecipe(tci.Ctx, tci.PlnK, msg)

				if !tc.testSecondExecuteRecipeError {
					require.True(t, err == nil)
				}
			}

			// test fulfill trade coin unlock
			if tc.testCreateTradeLock && tc.testFulfillTrade {
				lcFirst, _ := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				ffMsg := msgs.NewMsgFulfillTrade(
					ctRespData.TradeID,
					sender2,
					tc.testFulfillTradeInputItemIDs,
				)
				_, err = HandlerMsgFulfillTrade(tci.Ctx, tci.PlnK, ffMsg)

				require.True(t, err == nil)

				lcAfterFulfillTrade, err := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				require.True(t, err == nil)

				lcDiffer := lcFirst.Amount.Sort().Sub(lcAfterFulfillTrade.Amount.Sort())

				require.True(t, lcDiffer.IsEqual(tc.testFulfillTradeLockDiffer))

			}

			// test check execution coin unlock
			if tc.testExecuteRecipeLock && tc.testCheckExecution {
				lcFirst, _ := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				checkExec := msgs.NewMsgCheckExecution(scheduleOutput.ExecID, false, sender1)
				futureContext := tci.Ctx.WithBlockHeight(tci.Ctx.BlockHeight() + 3)
				result, _ := HandlerMsgCheckExecution(futureContext, tci.PlnK, checkExec)
				checkExecResp := CheckExecutionResponse{}

				err = json.Unmarshal(result.Data, &checkExecResp)
				require.True(t, err == nil)
				require.True(t, checkExecResp.Status == "Success")

				lcAfter, _ := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				lcDiffer := lcFirst.Amount.Sort().Sub(lcAfter.Amount.Sort())

				require.True(t, lcDiffer.IsEqual(tc.testCheckExecutionLockDiffer))

			}
		})
	}
}

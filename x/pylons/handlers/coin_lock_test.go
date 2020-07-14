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
		sdk.Coins{
			sdk.NewInt64Coin("chair", 100000),
			sdk.NewInt64Coin(types.Pylon, 100000),
		},
		sdk.Coins{
			sdk.NewInt64Coin("chair", 100000),
			sdk.NewInt64Coin(types.Pylon, 100000),
		},
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
		testExecuteRecipeAmount     sdk.Coins
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
		testSecondExecuteRecipe       bool
		testSecondExecuteRecipeAmount sdk.Coins
		testSecondExecuteRecipeError  bool
	}{
		"create trade and fulfill trade coin lock test": {
			testCreateTradeLock:       true,
			testCreateTradeAmount:     types.NewPylon(100),
			testCreateTradeLockDiffer: types.NewPylon(100),

			testFulfillTrade:             true,
			testFulfillTradeInputItemIDs: []string{},
			testFulfillTradeLockDiffer:   types.NewPylon(100),
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			ctRespData := CreateTradeResponse{}

			if tc.testCreateTradeLock {
				lcFirst, err := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				t.Log("\n\n\n------         Create trade coin lock test      ---------\n\n\n")
				t.Log("\nlcFirst:\n", lcFirst.String(), "\n\n")

				ctRespData, err = MockTrade(
					tci,
					types.GenCoinInputList("chair", 100),
					types.TradeItemInputList{},
					types.NewPylon(100),
					types.ItemList{},
					sender1,
				)

				if err != nil {
					t.Log(err)
				}

				require.True(t, err == nil)

				lcAfterCreateTrade, err := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)
				t.Log("\nlcAfterCreateTrade:\n", lcAfterCreateTrade.String(), "\n\n")

				lcDiffer := lcAfterCreateTrade.Amount.Sort().Sub(lcFirst.Amount.Sort())

				t.Log("\nlcDiffer:\n", lcDiffer.String(), "\n\n")

				require.True(t, lcDiffer.IsEqual(tc.testCreateTradeLockDiffer))

			}

			if tc.testCreateTradeLock && tc.testFulfillTrade {
				lcFirst, err := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)

				t.Log("\n\n\n------         Fulfill trade coin lock test      ---------\n\n\n")

				ffMsg := msgs.NewMsgFulfillTrade(
					ctRespData.TradeID,
					sender2,
					tc.testFulfillTradeInputItemIDs,
				)
				ffResult, err := HandlerMsgFulfillTrade(tci.Ctx, tci.PlnK, ffMsg)

				t.Log("\n\nfulfill trade result:\n", ffResult.Log)

				if err != nil {
					t.Log(err)
				}

				require.True(t, err == nil)

				lcAfterFulfillTrade, err := tci.PlnK.GetLockedCoin(tci.Ctx, sender1)
				t.Log("\nlcAfterFulfillTrade:\n", lcAfterFulfillTrade.String(), "\n\n")

				lcDiffer := lcFirst.Amount.Sort().Sub(lcAfterFulfillTrade.Amount.Sort())

				require.True(t, lcDiffer.IsEqual(tc.testFulfillTradeLockDiffer))

			}
		})
	}
}

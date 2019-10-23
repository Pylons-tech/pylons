package handlers

import (
	"encoding/json"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCheckExecution(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.PremiumTier.Fee)

	// mock cookbook
	cbData := MockCookbook(mockedCoinInput, sender1)

	// mock delayed coin to coin recipe
	c2cRecipeData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.GenCoinInputList("wood", 5),
		types.ItemInputList{},
		types.GenCoinOnlyEntry("chair"),
		cbData.CookbookID,
		5,
		sender1,
	)

	cases := map[string]struct {
		rcpID           string
		itemIDs         []string
		dynamicItemSet  bool
		dynamicItemName string
		sender          sdk.AccAddress
		payToComplete   bool
		addHeight       int64
		expectedMessage string
		expectError     bool
		coinAddition    int64
	}{
		"coin to coin recipe execution test": {
			rcpID:           c2cRecipeData.RecipeID,
			itemIDs:         []string{},
			sender:          sender1,
			payToComplete:   false,
			addHeight:       15,
			expectedMessage: "successfully completed the execution",
		},
		"coin to coin early pay recipe execution fail due to insufficient balance": {
			rcpID:           c2cRecipeData.RecipeID,
			itemIDs:         []string{},
			sender:          sender2,
			payToComplete:   true,
			expectError:     true,
			expectedMessage: "insufficient balance to complete the execution",
		},
		"coin to coin early pay recipe execution test": {
			rcpID:           c2cRecipeData.RecipeID,
			itemIDs:         []string{},
			sender:          sender2,
			payToComplete:   true,
			expectedMessage: "successfully paid to complete the execution",
			coinAddition:    300,
		},
		// TODO should add item generation delayed recipe test case
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.dynamicItemSet {
				dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, tc.dynamicItemName)
				mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *dynamicItem)
				tc.itemIDs = []string{dynamicItem.ID}
			}
			mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin("wood", 5)})

			execRcpResponse, err := MockExecution(mockedCoinInput, tc.rcpID,
				tc.sender,
				tc.itemIDs,
			)
			require.True(t, err == nil)
			require.True(t, execRcpResponse.Status == "Success")
			require.True(t, execRcpResponse.Message == "scheduled the recipe")

			if tc.coinAddition != 0 {
				_, _, err = mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, tc.sender, types.NewPylon(tc.coinAddition))
				require.True(t, err == nil)
			}

			scheduleOutput := ExecuteRecipeScheduleOutput{}
			err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
			require.True(t, err == nil)

			checkExec := msgs.NewMsgCheckExecution(scheduleOutput.ExecID, tc.payToComplete, tc.sender)

			futureContext := mockedCoinInput.Ctx.WithBlockHeight(mockedCoinInput.Ctx.BlockHeight() + tc.addHeight)
			result := HandlerMsgCheckExecution(futureContext, mockedCoinInput.PlnK, checkExec)
			checkExecResp := CheckExecutionResp{}
			err = json.Unmarshal(result.Data, &checkExecResp)
			require.True(t, err == nil)

			if tc.expectError {
				require.True(t, checkExecResp.Status == "Failure")
				require.True(t, checkExecResp.Message == tc.expectedMessage)

			} else {
				require.True(t, checkExecResp.Status == "Success")
				require.True(t, checkExecResp.Message == tc.expectedMessage)
			}
		})
	}
}

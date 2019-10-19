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

	// mock coin to coin recipe
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
		cookbookID      string
		itemIDs         []string
		dynamicItemSet  bool
		dynamicItemName string
		recipeID        string
		recipeDesc      string
		sender          sdk.AccAddress
		payToComplete   bool
		addHeight       int64
		expectedMessage string
		expectError     bool
		coinAddition    int64
	}{
		"coin to coin recipe execution test": {
			itemIDs:         []string{},
			recipeID:        c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			recipeDesc:      "this has to meet character limits lol",
			sender:          sender1,
			payToComplete:   false,
			addHeight:       15,
			expectedMessage: "successfully completed the execution",
		},
		"coin to coin early pay recipe execution fail due to insufficient balance": {
			itemIDs:         []string{},
			recipeID:        c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			recipeDesc:      "this has to meet character limits lol",
			sender:          sender2,
			payToComplete:   true,
			expectError:     true,
			expectedMessage: "insufficient balance to complete the execution",
		},
		"coin to coin early pay recipe execution test": {
			itemIDs:         []string{},
			recipeID:        c2cRecipeData.RecipeID, // coin 2 coin Recipe ID
			recipeDesc:      "this has to meet character limits lol",
			sender:          sender2,
			payToComplete:   true,
			expectedMessage: "successfully paid to complete the execution",
			coinAddition:    300,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			if tc.dynamicItemSet {
				dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, tc.dynamicItemName)
				mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *dynamicItem)
				tc.itemIDs = []string{dynamicItem.ID}
			}
			mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, tc.sender, sdk.Coins{sdk.NewInt64Coin("wood", 5)})

			msg := msgs.NewMsgExecuteRecipe(tc.recipeID, tc.sender, tc.itemIDs)
			result := HandlerMsgExecuteRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			execRcpResponse := ExecuteRecipeResp{}
			err := json.Unmarshal(result.Data, &execRcpResponse)

			require.True(t, err == nil)
			require.True(t, execRcpResponse.Status == "Success")
			require.True(t, execRcpResponse.Message == "scheduled the recipe")

			if tc.coinAddition != 0 {
				_, _, err = mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, tc.sender, types.NewPylon(tc.coinAddition))
				require.True(t, err == nil)

			}
			execs, err := mockedCoinInput.PlnK.GetExecutionsBySender(mockedCoinInput.Ctx, tc.sender)
			require.True(t, err == nil)

			checkExec := msgs.NewMsgCheckExecution(execs[0].ID, tc.payToComplete, tc.sender)

			futureContext := mockedCoinInput.Ctx.WithBlockHeight(mockedCoinInput.Ctx.BlockHeight() + tc.addHeight)
			result = HandlerMsgCheckExecution(futureContext, mockedCoinInput.PlnK, checkExec)
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

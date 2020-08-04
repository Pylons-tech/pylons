package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestRecipeFlowUpdate(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, sdk.Coins{
		sdk.NewInt64Coin("chair", 100000),
		sdk.NewInt64Coin("wood", 100000),
		sdk.NewInt64Coin(types.Pylon, 100000),
	}, nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	cases := map[string]struct {
		cbID         string
		recipeName   string
		rcpID        string
		recipeDesc   string
		sender       sdk.AccAddress
		desiredError string
		showError    bool

		dynamicItemSet   bool
		dynamicItemNames []string
	}{
		"successful test for update recipe": {
			cbID:       cbData.CookbookID,
			recipeName: "recipe0001",
			// rcpID:        recipeData.RecipeID, // available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "",
			showError:    false,

			dynamicItemSet:   true,
			dynamicItemNames: []string{"Raichu"},
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			// Create recipe

			// mock new recipe
			newRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "", "this has to meet character limits",
				types.GenCoinInputList("wood", 5),
				types.GenItemInputList("Raichu"),
				types.GenEntries("chair", "Raichu"),
				types.GenOneOutput("chair", "Raichu"),
				0,
				tc.sender,
			)

			newRcpResult, _ := HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, newRcpMsg)
			recipeData := CreateRecipeResponse{}
			err := json.Unmarshal(newRcpResult.Data, &recipeData)
			require.True(t, err == nil)

			tc.rcpID = recipeData.RecipeID

			// Create dynamic items
			itemIDs := []string{}
			if tc.dynamicItemSet {
				for _, iN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, iN)
					err := tci.PlnK.SetItem(tci.Ctx, *dynamicItem)
					require.True(t, err == nil)
					itemIDs = append(itemIDs, dynamicItem.ID)
				}
			}

			// Run recipe exeuction for the recipe
			execRcpResponse, err := MockExecution(tci, tc.rcpID,
				tc.sender,
				itemIDs,
			)
			require.True(t, err == nil)
			require.True(t, execRcpResponse.Status == "Success")
			t.Log(execRcpResponse.Message)

			// Update recipe
			msg := msgs.NewMsgUpdateRecipe(tc.recipeName, tc.cbID, tc.rcpID, tc.recipeDesc,
				types.GenCoinInputList("wood", 5),
				types.GenItemInputList("Raichu"),
				types.GenEntries("chair", "Raichu"),
				types.GenOneOutput("chair", "Raichu"),
				3,
				sender1)

			result, err := HandlerMsgUpdateRecipe(tci.Ctx, tci.PlnK, msg)

			if tc.showError == false {
				recipeData := UpdateRecipeResponse{}
				err := json.Unmarshal(result.Data, &recipeData)
				require.True(t, err == nil)
				require.True(t, len(recipeData.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}

			// Create dynamic items
			itemIDs = []string{}
			if tc.dynamicItemSet {
				for _, iN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, iN)
					err := tci.PlnK.SetItem(tci.Ctx, *dynamicItem)
					require.True(t, err == nil)
					itemIDs = append(itemIDs, dynamicItem.ID)
				}
			}

			// Create exeuction for the recipe
			execRcpResponse, err = MockExecution(tci, tc.rcpID,
				tc.sender,
				itemIDs,
			)
			require.True(t, err == nil)
			require.True(t, execRcpResponse.Status == "Success")
			t.Log(execRcpResponse.Message)

			// Schedule Recipe
			scheduleOutput := ExecuteRecipeScheduleOutput{}
			err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
			require.True(t, err == nil)

			if tc.dynamicItemSet && len(itemIDs) > 0 {
				usedItem, err := tci.PlnK.GetItem(tci.Ctx, itemIDs[0])
				require.True(t, err == nil)
				require.True(t, usedItem.OwnerRecipeID == tc.rcpID)
			}

			// Check execution
			checkExec := msgs.NewMsgCheckExecution(scheduleOutput.ExecID, false, tc.sender)

			futureContext := tci.Ctx.WithBlockHeight(tci.Ctx.BlockHeight() + 3)
			checkMsgResult, _ := HandlerMsgCheckExecution(futureContext, tci.PlnK, checkExec)
			checkExecResp := CheckExecutionResponse{}
			err = json.Unmarshal(checkMsgResult.Data, &checkExecResp)
			require.True(t, err == nil)

			if tc.showError {
				require.True(t, checkExecResp.Status == "Failure")
				require.True(t, checkExecResp.Message == tc.desiredError)

			} else {
				require.True(t, checkExecResp.Status == "Success")
			}
		})
	}
}

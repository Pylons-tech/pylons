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
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
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
			cbID:         cbData.CookbookID,
			recipeName:   "recipe0001",
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
			genCoinsList := types.GenCoinInputList("wood", 5)
			mInputList := types.GenItemInputList("Raichu")
			mEntries := types.GenEntries("chair", "Raichu")
			mOutputs := types.GenOneOutput("chair", "Raichu")
			newRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "", "this has to meet character limits",
				genCoinsList,
				mInputList,
				mEntries,
				mOutputs,
				0,
				tc.sender.String(),
			)

			newRcpResult, _ := tci.PlnH.CreateRecipe(sdk.WrapSDKContext(tci.Ctx), &newRcpMsg)
			tc.rcpID = newRcpResult.RecipeID

			// Create dynamic items
			itemIDs := []string{}
			if tc.dynamicItemSet {
				for _, iN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, iN)
					err := tci.PlnK.SetItem(tci.Ctx, dynamicItem)
					require.NoError(t, err)
					itemIDs = append(itemIDs, dynamicItem.ID)
				}
			}

			// Run recipe exeuction for the recipe
			execRcpResponse, err := MockExecution(tci, tc.rcpID,
				tc.sender,
				itemIDs,
			)
			require.NoError(t, err)
			require.True(t, execRcpResponse.Status == "Success")
			t.Log(execRcpResponse.Message)

			// Update recipe
			msg := msgs.NewMsgUpdateRecipe(tc.rcpID, tc.recipeName, tc.cbID, tc.recipeDesc,
				genCoinsList,
				mInputList,
				mEntries,
				mOutputs,
				3,
				sender1)

			result, err := tci.PlnH.HandlerMsgUpdateRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError == false {
				require.True(t, len(result.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}

			// Create dynamic items
			itemIDs = []string{}
			if tc.dynamicItemSet {
				for _, iN := range tc.dynamicItemNames {
					dynamicItem := keep.GenItem(cbData.CookbookID, tc.sender, iN)
					err := tci.PlnK.SetItem(tci.Ctx, dynamicItem)
					require.NoError(t, err)
					itemIDs = append(itemIDs, dynamicItem.ID)
				}
			}

			// Create exeuction for the recipe
			execRcpResponse, err = MockExecution(tci, tc.rcpID,
				tc.sender,
				itemIDs,
			)
			require.NoError(t, err)
			require.True(t, execRcpResponse.Status == "Success")
			t.Log(execRcpResponse.Message)

			// Schedule Recipe
			scheduleOutput := ExecuteRecipeScheduleOutput{}
			err = json.Unmarshal(execRcpResponse.Output, &scheduleOutput)
			require.NoError(t, err)

			if tc.dynamicItemSet && len(itemIDs) > 0 {
				usedItem, err := tci.PlnK.GetItem(tci.Ctx, itemIDs[0])
				require.NoError(t, err)
				require.True(t, usedItem.OwnerRecipeID == tc.rcpID)
			}

			// Check execution
			checkExec := msgs.NewMsgCheckExecution(scheduleOutput.ExecID, false, tc.sender)

			futureContext := tci.Ctx.WithBlockHeight(tci.Ctx.BlockHeight() + 3)
			checkMsgResult, _ := tci.PlnH.CheckExecution(sdk.WrapSDKContext(futureContext), &checkExec)

			if tc.showError {
				require.True(t, checkMsgResult.Status == "Failure")
				require.True(t, checkMsgResult.Message == tc.desiredError)

			} else {
				require.True(t, checkMsgResult.Status == "Success")
			}
		})
	}
}

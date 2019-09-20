package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgUpdateRecipe(t *testing.T) {
	mockedCoinInput := setupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	mockedCoinInput.bk.AddCoins(mockedCoinInput.ctx, sender1, types.PremiumTier.Fee)

	// mock cookbook
	cbData := mockCookbook(mockedCoinInput, sender1)

	// mock new recipe
	newRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "this has to meet character limits",
		types.GenCoinInputList("wood", 5),
		types.GenCoinOutputList("chair", 1),
		types.GenItemInputList("Raichu"),
		types.GenItemOutputList("Raichu"),
		sender1,
	)

	newRcpResult := HandlerMsgCreateRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, newRcpMsg)
	recipeData := CreateRecipeResponse{}
	json.Unmarshal(newRcpResult.Data, &recipeData)

	cases := map[string]struct {
		cookbookId   string
		recipeName   string
		recipeID     string
		recipeDesc   string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"update recipe check for not available recipe": {
			cookbookId:   cbData.CookbookID,
			recipeName:   "recipe0001",
			recipeID:     "id001", // not available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "the owner of the recipe is different then the current sender",
			showError:    true,
		},
		"successful test for update recipe": {
			cookbookId:   cbData.CookbookID,
			recipeName:   "recipe0001",
			recipeID:     recipeData.RecipeID, // available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgUpdateRecipe(tc.recipeName, tc.cookbookId, tc.recipeID, tc.recipeDesc,
				types.GenCoinInputList("wood", 5),
				types.GenCoinOutputList("chair", 1),
				types.GenItemInputList("Raichu"),
				types.GenItemOutputList("Raichu"),
				sender1)

			result := HandlerMsgUpdateRecipe(mockedCoinInput.ctx, mockedCoinInput.plnK, msg)

			if tc.showError == false {
				recipeData := UpdateRecipeResponse{}
				err := json.Unmarshal(result.Data, &recipeData)
				require.True(t, err == nil)
				require.True(t, len(recipeData.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}

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

func TestHandlerMsgUpdateRecipe(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	_, err := mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.NewPylon(1000000))
	require.True(t, err == nil)

	// mock cookbook
	cbData := MockCookbook(mockedCoinInput, sender1)

	// mock new recipe
	newRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "", "this has to meet character limits",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("Raichu"),
		types.GenEntries("chair", "Raichu"),
		types.GenOneOutput(2),
		0,
		sender1,
	)

	newRcpResult, _ := HandlerMsgCreateRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, newRcpMsg)
	recipeData := CreateRecipeResponse{}
	err = json.Unmarshal(newRcpResult.Data, &recipeData)
	require.True(t, err == nil)

	cases := map[string]struct {
		cookbookID   string
		recipeName   string
		recipeID     string
		recipeDesc   string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"update recipe check for not available recipe": {
			cookbookID:   cbData.CookbookID,
			recipeName:   "recipe0001",
			recipeID:     "id001", // not available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "the owner of the recipe is different then the current sender",
			showError:    true,
		},
		"successful test for update recipe": {
			cookbookID:   cbData.CookbookID,
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
			msg := msgs.NewMsgUpdateRecipe(tc.recipeName, tc.cookbookID, tc.recipeID, tc.recipeDesc,
				types.GenCoinInputList("wood", 5),
				types.GenItemInputList("Raichu"),
				types.GenEntries("chair", "Raichu"),
				types.GenOneOutput(2),
				sender1)

			result, err := HandlerMsgUpdateRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			if tc.showError == false {
				recipeData := UpdateRecipeResponse{}
				err := json.Unmarshal(result.Data, &recipeData)
				require.True(t, err == nil)
				require.True(t, len(recipeData.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

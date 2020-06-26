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
	tci := keep.SetupTestCoinInput()
	// sender1, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000))
	sender1, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock new recipe
	newRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "", "this has to meet character limits",
		types.GenCoinInputList("wood", 5),
		types.GenItemInputList("Raichu"),
		types.GenEntries("chair", "Raichu"),
		types.GenOneOutput(2),
		0,
		sender1,
	)

	newRcpResult, _ := HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, newRcpMsg)
	recipeData := CreateRecipeResponse{}
	err := json.Unmarshal(newRcpResult.Data, &recipeData)
	require.True(t, err == nil)

	cases := map[string]struct {
		cbID         string
		recipeName   string
		rcpID        string
		recipeDesc   string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"update recipe check for not available recipe": {
			cbID:         cbData.CookbookID,
			recipeName:   "recipe0001",
			rcpID:        "id001", // not available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "the owner of the recipe is different then the current sender",
			showError:    true,
		},
		"successful test for update recipe": {
			cbID:         cbData.CookbookID,
			recipeName:   "recipe0001",
			rcpID:        recipeData.RecipeID, // available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgUpdateRecipe(tc.recipeName, tc.cbID, tc.rcpID, tc.recipeDesc,
				types.GenCoinInputList("wood", 5),
				types.GenItemInputList("Raichu"),
				types.GenEntries("chair", "Raichu"),
				types.GenOneOutput(2),
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
		})
	}
}

package handlers

import (
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
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock new recipe
	genCoinList := types.GenCoinInputList("wood", 5)
	genItemInputList := types.GenItemInputList("Raichu")
	genEntries := types.GenEntries("chair", "Raichu")
	genOneOutput := types.GenOneOutput("chair", "Raichu")
	newRcpMsg := msgs.NewMsgCreateRecipe("existing recipe", cbData.CookbookID, "", "this has to meet character limits",
		genCoinList,
		genItemInputList,
		genEntries,
		genOneOutput,
		0,
		sender1.String(),
	)

	newRcpResult, _ := tci.PlnH.CreateRecipe(sdk.WrapSDKContext(tci.Ctx), &newRcpMsg)

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
			rcpID:        newRcpResult.RecipeID, // available ID
			recipeDesc:   "this has to meet character limits lol",
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			genCoinList := types.GenCoinInputList("wood", 5)
			genItemInputList := types.GenItemInputList("Raichu")
			genEntries := types.GenEntries("chair", "Raichu")
			genOneOutput := types.GenOneOutput("chair", "Raichu")
			msg := msgs.NewMsgUpdateRecipe(tc.rcpID, tc.recipeName, tc.cbID, tc.recipeDesc,
				genCoinList,
				genItemInputList,
				genEntries,
				genOneOutput,
				0,
				sender1)

			result, err := tci.PlnH.HandlerMsgUpdateRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError == false {
				require.True(t, len(result.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

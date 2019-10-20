package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateRecipe(t *testing.T) {

	// TODO after HandlerMsgCreateRecipe struct is updated, this function should be updated too
	mockedCoinInput := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

	cases := map[string]struct {
		cookbookName   string
		createCookbook bool
		recipeDesc     string
		sender         sdk.AccAddress
		desiredError   string
		showError      bool
	}{
		"cookbook owner check": {
			cookbookName:   "book000001",
			createCookbook: false,
			recipeDesc:     "this has to meet character limits",
			sender:         sender,
			desiredError:   "cookbook not owned by the sender",
			showError:      true,
		},
		"successful check": {
			cookbookName:   "book000001",
			createCookbook: true,
			recipeDesc:     "this has to meet character limits",
			sender:         sender,
			desiredError:   "",
			showError:      false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cbData := CreateCBResponse{}
			if tc.createCookbook {
				cookbookMsg := msgs.NewMsgCreateCookbook(tc.cookbookName, "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, tc.sender)
				cookbookResult := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, cookbookMsg)

				err := json.Unmarshal(cookbookResult.Data, &cbData)
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			}

			msg := msgs.NewMsgCreateRecipe("name", cbData.CookbookID, tc.recipeDesc,
				types.GenCoinInputList("wood", 5),
				types.GenItemInputList("Raichu"),
				types.GenEntries("chair", "Raichu"),
				0,
				tc.sender,
			)

			result := HandlerMsgCreateRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)
			if !tc.showError {
				recipeData := CreateRecipeResponse{}
				err := json.Unmarshal(result.Data, &recipeData)
				require.True(t, err == nil)
				require.True(t, len(recipeData.RecipeID) > 0)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}

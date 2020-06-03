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

func TestHandlerMsgEnableRecipe(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, sender2 := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000))

	// mock cookbook
	cbData := MockCookbook(tci, sender1)

	// mock recipe
	rcpData := MockPopularRecipe(RCP_DEFAULT, tci, "existing recipe", cbData.CookbookID, sender1)

	cases := map[string]struct {
		recipeID     string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"wrong recipe check": {
			recipeID:     "invalidRecipeID",
			sender:       sender1,
			desiredError: "The recipe doesn't exist",
			showError:    true,
		},
		"owner of recipe check": {
			recipeID:     rcpData.RecipeID,
			sender:       sender2,
			desiredError: "msg sender is not the owner of the recipe",
			showError:    true,
		},
		"successful update check": {
			recipeID:     rcpData.RecipeID,
			sender:       sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgEnableRecipe(tc.recipeID, tc.sender)
			result, err := HandlerMsgEnableRecipe(tci.Ctx, tci.PlnK, msg)

			if tc.showError == false {
				enableRcpResponse := EnableRecipeResp{}
				err := json.Unmarshal(result.Data, &enableRcpResponse)

				require.True(t, err == nil)
				require.True(t, enableRcpResponse.Status == "Success")
				require.True(t, enableRcpResponse.Message == "successfully enabled the recipe")

				uRcp, err2 := tci.PlnK.GetRecipe(tci.Ctx, tc.recipeID)
				require.True(t, err2 == nil)
				require.True(t, uRcp.Disabled == false)
			} else {
				// t.Errorf("EnableRecipeTEST LOG:: %+v", result)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}

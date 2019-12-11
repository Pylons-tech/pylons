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

func TestHandlerMsgEnableRecipe(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.PremiumTier.Fee)

	// mock cookbook
	cbData := MockCookbook(mockedCoinInput, sender1)

	// mock recipe
	rcpData := MockRecipe(
		mockedCoinInput, "existing recipe",
		types.GENERATION,
		types.GenCoinInputList("wood", 5),
		types.ItemInputList{},
		types.GenEntries("chair", "Raichu"),
		types.ItemUpgradeParams{},
		cbData.CookbookID,
		0,
		sender1,
	)

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
			result := HandlerMsgEnableRecipe(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			if tc.showError == false {
				enableRcpResponse := EnableRecipeResp{}
				err := json.Unmarshal(result.Data, &enableRcpResponse)

				require.True(t, err == nil)
				require.True(t, enableRcpResponse.Status == "Success")
				require.True(t, enableRcpResponse.Message == "successfully enabled the recipe")

				uRcp, err2 := mockedCoinInput.PlnK.GetRecipe(mockedCoinInput.Ctx, tc.recipeID)
				require.True(t, err2 == nil)
				require.True(t, uRcp.Disabled == false)
			} else {
				// t.Errorf("EnableRecipeTEST LOG:: %+v", result)
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}

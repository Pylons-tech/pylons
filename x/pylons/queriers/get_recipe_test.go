package queriers

// TODO should write queriers.get_recipe test

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestGetRecipe(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender := "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	senderAccAddress, _ := sdk.AccAddressFromBech32(sender)

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.PremiumTier.Fee)

	// mock cookbook
	cbData := handlers.MockCookbook(mockedCoinInput, senderAccAddress)

	// mock recipe
	mockRecipeName := "GET_RECIPE_MOCK_TEST_NAME"
	rcpData := handlers.MockRecipe(
		mockedCoinInput, mockRecipeName,
		types.GenCoinInputList("wood", 5),
		types.ItemInputList{},
		types.GenCoinOnlyEntry("chair"),
		cbData.CookbookID,
		5,
		senderAccAddress,
	)
	// mockedItem := keep.GenItem(cbData.CookbookID, senderAccAddress, mockItemName)
	// mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *mockedItem)

	cases := map[string]struct {
		path          []string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		rcpName       string
	}{
		"error check when providing invalid recipe ID": {
			path:          []string{"invalid recipeID"},
			showError:     true,
			desiredError:  "The recipe doesn't exist",
			desiredRcpCnt: 0,
		},
		"error check when not providing recipeID": {
			path:          []string{},
			showError:     true,
			desiredError:  "no recipe id is provided in path",
			desiredRcpCnt: 0,
		},
		"get recipe successful check": {
			path:          []string{rcpData.RecipeID},
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			rcpName:       mockRecipeName,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := GetRecipe(
				mockedCoinInput.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				mockedCoinInput.PlnK,
			)
			// t.Errorf("GetRecipeTEST LOG:: %+v, %+v", err, result)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				readRecipe := types.Recipe{}
				readRecipeErr := mockedCoinInput.PlnK.Cdc.UnmarshalJSON(result, &readRecipe)

				require.True(t, readRecipeErr == nil)
				require.True(t, readRecipe.Name == tc.rcpName)
			}
		})
	}
}

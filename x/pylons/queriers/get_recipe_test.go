package queriers

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGetRecipe(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	// mock recipe
	mockRecipeName := "GET_RECIPE_MOCK_TEST_NAME"
	rcpData := handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		mockRecipeName, cbData.CookbookID, sender1)

	cases := map[string]struct {
		recipeID      string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		rcpName       string
	}{
		"error check when providing invalid recipe ID": {
			recipeID:      "invalid recipeID",
			showError:     true,
			desiredError:  "The recipe doesn't exist",
			desiredRcpCnt: 0,
		},
		"error check when not providing recipeID": {
			recipeID:      "",
			showError:     true,
			desiredError:  "no recipe id is provided in path",
			desiredRcpCnt: 0,
		},
		"get recipe successful check": {
			recipeID:      rcpData.RecipeID,
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			rcpName:       mockRecipeName,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.GetRecipe(
				sdk.WrapSDKContext(tci.Ctx),
				&types.GetRecipeRequest{
					RecipeID: tc.recipeID,
				},
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				require.True(t, result.Name == tc.rcpName)
			}
		})
	}
}

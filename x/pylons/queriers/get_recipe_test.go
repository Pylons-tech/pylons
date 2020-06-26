package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGetRecipe(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	// sender1, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000))
	sender1, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	// mock recipe
	mockRecipeName := "GET_RECIPE_MOCK_TEST_NAME"
	rcpData := handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		mockRecipeName, cbData.CookbookID, sender1)

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
				tci.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				tci.PlnK,
			)
			// t.Errorf("GetRecipeTEST LOG:: %+v, %+v", err, result)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				readRecipe := types.Recipe{}
				readRecipeErr := tci.PlnK.Cdc.UnmarshalJSON(result, &readRecipe)

				require.True(t, readRecipeErr == nil)
				require.True(t, readRecipe.Name == tc.rcpName)
			}
		})
	}
}

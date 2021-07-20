package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGetRecipe(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	// mock recipe
	mockRecipeName := "GET_RECIPE_MOCK_TEST_NAME"
	rcpData := handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		mockRecipeName, cbData.CookbookID, sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "card")

	cases := map[string]struct {
		recipeID      string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		rcpName       string
	}{
		"error check when providing invalid recipe ID": {
			recipeID:      "invalidRecipeID",
			showError:     true,
			desiredError:  "key invalidRecipeID not present in recipe store",
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
				require.NoError(t, err)
				require.Equal(t, result.Name, tc.rcpName)
			}
		})
	}
}

func TestListRecipe(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	// mock cookbook
	cbData := handlers.MockCookbook(tci, sender1)

	handlers.MockPopularRecipe(handlers.Rcp5BlockDelayed5xWoodcoinTo1xChaircoin, tci,
		"recipe0001", cbData.CookbookID, sender1, "pi_1DoShv2eZvKYlo2CqsROyFun", "card")

	cases := map[string]struct {
		address       string
		desiredError  string
		showError     bool
		desiredRcpCnt int
		firstItemName string
	}{
		"error check when providing invalid address": {
			address:       "invalid_address",
			showError:     true,
			desiredError:  "decoding bech32 failed: invalid index of 1",
			desiredRcpCnt: 0,
		},
		"error check when not providing address": {
			address:       "",
			showError:     false,
			desiredRcpCnt: 1,
			firstItemName: "recipe0001",
		},
		"list recipe successful check": {
			address:       sender1.String(),
			showError:     false,
			desiredError:  "",
			desiredRcpCnt: 1,
			firstItemName: "recipe0001",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.ListRecipe(
				sdk.WrapSDKContext(tci.Ctx),
				&types.ListRecipeRequest{
					Address: tc.address,
				},
			)
			if tc.showError {
				require.Error(t, err)
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
				require.Equal(t, len(result.Recipes), tc.desiredRcpCnt)
				require.True(t, len(result.Recipes) > 0)
				require.Equal(t, result.Recipes[0].Name, tc.firstItemName)
			}
		})
	}
}

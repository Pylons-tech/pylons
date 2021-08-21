package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNRecipe(k *keeper.Keeper, ctx sdk.Context, cb types.Cookbook, n int) []types.Recipe {
	items := make([]types.Recipe, n)
	for i := range items {
		items[i].CookbookID = cb.ID
		items[i].ID = fmt.Sprintf("%d", i)
		k.SetRecipe(ctx, items[i])
	}
	return items
}

func (suite *IntegrationTestSuite) TestRecipeGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	cookbooks := createNCookbook(k, ctx, 1)
	items := createNRecipe(&k, ctx, cookbooks[0], 10)
	for _, item := range items {
		rst, found := k.GetRecipe(ctx, cookbooks[0].ID, item.ID)
		require.True(found)
		require.Equal(item, rst)
	}
}

func (suite *IntegrationTestSuite) TestRecipeGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	cookbooks := createNCookbook(k, ctx, 1)
	items := createNRecipe(&k, ctx, cookbooks[0], 10)
	require.Equal(items, k.GetAllRecipe(ctx))
}

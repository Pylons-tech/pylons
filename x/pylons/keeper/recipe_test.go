package keeper_test

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

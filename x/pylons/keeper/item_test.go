package keeper_test

func (suite *IntegrationTestSuite) TestItemGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNItem(k, ctx, 10, true)
	for _, item := range items {
		rst, found := k.GetItem(ctx, item.CookbookID, item.ID)
		require.True(found)
		require.Equal(item, rst)
	}
}

func (suite *IntegrationTestSuite) TestItemGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNItem(k, ctx, 10, true)
	require.Equal(items, k.GetAllItem(ctx))
}

func (suite *IntegrationTestSuite) TestItemCountGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	expectedCount := 10
	createNItem(k, ctx, expectedCount, true)
	for i := 0; i < expectedCount; i++ {
		count := k.GetItemCount(ctx)
		require.Equal(uint64(expectedCount), count)
	}
}

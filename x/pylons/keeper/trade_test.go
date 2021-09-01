package keeper_test

func (suite *IntegrationTestSuite) TestTradeGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	for _, item := range items {
		require.Equal(item, k.GetTrade(ctx, item.ID))
	}
}

func (suite *IntegrationTestSuite) TestTradeExist() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	for _, item := range items {
		require.True(k.HasTrade(ctx, item.ID))
	}
}

func (suite *IntegrationTestSuite) TestTradeRemove() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	for _, item := range items {
		k.RemoveTrade(ctx, item.ID)
		require.False(k.HasTrade(ctx, item.ID))
	}
}

func (suite *IntegrationTestSuite) TestTradeGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	require.Equal(items, k.GetAllTrade(ctx))
}

func (suite *IntegrationTestSuite) TestTradeCount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	count := uint64(len(items))
	require.Equal(count, k.GetTradeCount(ctx))
}

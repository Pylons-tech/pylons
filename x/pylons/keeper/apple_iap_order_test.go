package keeper_test

func (suite *IntegrationTestSuite) TestAppleIAPOrderGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNAppleIAPOrder(k, ctx, 10)
	for _, item := range items {
		require.Equal(item, k.GetAppleIAPOrder(ctx, item.TransactionID))
	}
}

func (suite *IntegrationTestSuite) TestAppleIAPOrderExist() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNAppleIAPOrder(k, ctx, 10)
	for _, item := range items {
		require.True(k.HasAppleIAPOrder(ctx, item.TransactionID))
	}
}

func (suite *IntegrationTestSuite) TestAppleIAPOrderGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNAppleIAPOrder(k, ctx, 10)
	require.Equal(items, k.GetAllAppleIAPOrder(ctx))
	require.Equal(items, k.GetAllAppleIAPOrder(ctx))
}

func (suite *IntegrationTestSuite) TestAppleIAPOrderCount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNAppleIAPOrder(k, ctx, 10)
	count := uint64(len(items))
	require.Equal(count, k.GetAppleIAPOrderCount(ctx))
}

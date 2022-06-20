package keeper_test

func (suite *IntegrationTestSuite) TestRedeemInfoGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNRedeemInfo(k, ctx, 10)
	for _, item := range items {
		rst, found := k.GetRedeemInfo(ctx, item.Id)
		require.True(found)
		require.Equal(item, rst)
	}
}

func (suite *IntegrationTestSuite) TestRedeemInfoGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNRedeemInfo(k, ctx, 10)
	require.Equal(items, k.GetAllRedeemInfo(ctx))
}

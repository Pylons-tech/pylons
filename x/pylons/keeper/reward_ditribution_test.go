package keeper_test

func (suite *IntegrationTestSuite) TestGetRewardDistribution() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createRewardDistributionOrder(k, ctx, 10)
	for _, item := range items {
		require.Equal(item, k.GetRewardDistribution(ctx, item.Receiver))
	}

}

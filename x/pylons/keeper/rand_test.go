package keeper_test

func (suite *IntegrationTestSuite) TestRandomSeed() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	seed := k.RandomSeed(ctx)
	require.Equal(seed, k.RandomSeed(ctx)) // should be the same value since AppHash is unchanged
}

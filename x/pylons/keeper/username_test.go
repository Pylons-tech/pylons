package keeper_test

func (suite *IntegrationTestSuite) TestUsernameGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	usernames := createNUsername(k, ctx, 10)
	for _, username := range usernames {
		rst, found := k.GetUsername(ctx, username.Creator)
		require.True(found)
		require.Equal(username, rst)
	}
}
func (suite *IntegrationTestSuite) TestUsernameRemove() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	usernames := createNUsername(k, ctx, 10)
	for _, username := range usernames {
		k.RemoveUsername(ctx, username.Creator)
		_, found := k.GetUsername(ctx, username.Creator)
		require.False(found)
	}
}

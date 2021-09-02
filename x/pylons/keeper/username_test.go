package keeper_test

func (suite *IntegrationTestSuite) TestUsernameGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	accounts := createNPylonsAccount(k, ctx, 10)
	for _, account := range accounts {
		rst, found := k.GetPylonsAccount(ctx, account.Username)
		require.True(found)
		require.Equal(account, rst)
	}
}
func (suite *IntegrationTestSuite) TestUsernameRemove() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	accounts := createNPylonsAccount(k, ctx, 10)
	for _, account := range accounts {
		k.RemovePylonsAccount(ctx, account.Username)
		_, found := k.GetPylonsAccount(ctx, account.Username)
		require.False(found)
	}
}

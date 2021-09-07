package keeper_test

func (suite *IntegrationTestSuite) TestUsernameGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	accounts := createNPylonsAccount(k, ctx, 10)
	for _, account := range accounts {
		rst, found := k.GetPylonsAccountByUsername(ctx, account.Username)
		require.True(found)
		require.Equal(account, rst)
	}
}

func (suite *IntegrationTestSuite) TestAccountGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	accounts := createNPylonsAccount(k, ctx, 10)
	for _, account := range accounts {
		rst, found := k.GetPylonsAccountByAddress(ctx, account.Account)
		require.True(found)
		require.Equal(account, rst)
	}
}

package keeper_test

func (suite *IntegrationTestSuite) TestUsernameGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	accounts := createNPylonsAccount(k, ctx, 10)
	for _, account := range accounts {
		rst, found := k.GetAddressByUsername(ctx, account.Username)
		require.True(found)
		require.Equal(account.AccountAddr, rst.Value)
	}
}

func (suite *IntegrationTestSuite) TestAccountGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	accounts := createNPylonsAccount(k, ctx, 10)
	for _, account := range accounts {
		rst, found := k.GetUsernameByAddress(ctx, account.AccountAddr)
		require.True(found)
		require.Equal(account.Username, rst.Value)
	}
}

func (suite *IntegrationTestSuite) TestAccountGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	accounts := createNPylonsAccount(k, ctx, 10)
	list := k.GetAllPylonsAccount(ctx)
	require.Equal(accounts, list)
}

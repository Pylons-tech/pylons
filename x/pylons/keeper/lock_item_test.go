package keeper_test

func (suite *IntegrationTestSuite) TestLockItemForExecution() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	orig := createNItem(&k, ctx, 1)
	k.LockItemForExecution(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookID, orig[0].ID)
	require.Equal(item.Owner, k.ExecutionsLockerAddress().String())
}

func (suite *IntegrationTestSuite)  TestLockItemForTrade() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	orig := createNItem(&k, ctx, 1)
	k.LockItemForTrade(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookID, orig[0].ID)
	require.Equal(item.Owner, k.TradesLockerAddress().String())
}

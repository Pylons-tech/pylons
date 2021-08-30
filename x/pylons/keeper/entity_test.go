package keeper_test

func (suite *IntegrationTestSuite) TestGetEntityCount() {
	//k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	value := k.GetEntityCount(ctx)
	var expected uint64 = 0
	require.Equal(expected, value)

	expected = 999
	k.SetEntityCount(ctx, expected)
	value = k.GetEntityCount(ctx)
	require.Equal(expected, value)
}


func (suite *IntegrationTestSuite) TestSetEntityCount() {
	//k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	var expected uint64 = 999
	k.SetEntityCount(ctx, expected)
	value := k.GetEntityCount(ctx)
	require.Equal(expected, value)
}

func (suite *IntegrationTestSuite) TestIncrementEntityCount() {
	//k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	var expected uint64 = 1
	k.IncrementEntityCount(ctx)

	value := k.GetEntityCount(ctx)

	require.Equal(expected, value)

	k.IncrementEntityCount(ctx)

	value = k.GetEntityCount(ctx)

	expected = 2

	require.Equal(expected, value)
}
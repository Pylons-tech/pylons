package keeper_test

import sdk "github.com/cosmos/cosmos-sdk/types"

func (suite *IntegrationTestSuite) TestCookbookGet() {
	// k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNCookbook(k, ctx, 10)
	for _, item := range items {
		rst, found := k.GetCookbook(ctx, item.ID)
		suite.Require()
		require.True(found)
		require.Equal(item, rst)
	}
}

func (suite *IntegrationTestSuite) TestCookbookGetAll() {
	// k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNCookbook(k, ctx, 10)
	require.Equal(items, k.GetAllCookbook(ctx))
}

func (suite *IntegrationTestSuite) TestCookbookGetAllByCreator() {
	// k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNCookbook(k, ctx, 10)
	for _, item := range items {
		addr, _ := sdk.AccAddressFromBech32(item.Creator)
		rst := k.GetAllCookbookByCreator(ctx, addr)
		require.Equal(item, rst[0])
	}
}

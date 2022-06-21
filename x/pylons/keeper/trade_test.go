package keeper_test

import sdk "github.com/cosmos/cosmos-sdk/types"

func (suite *IntegrationTestSuite) TestTradeGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	for _, item := range items {
		require.Equal(item, k.GetTrade(ctx, item.Id))
	}
}

func (suite *IntegrationTestSuite) TestTradeExist() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	for _, item := range items {
		require.True(k.HasTrade(ctx, item.Id))
	}
}

func (suite *IntegrationTestSuite) TestTradeRemove() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	for _, item := range items {

		addr, err := sdk.AccAddressFromBech32(item.Creator)
		require.NoError(err)
		k.RemoveTrade(ctx, item.Id, addr)
		require.False(k.HasTrade(ctx, item.Id))
	}
}

func (suite *IntegrationTestSuite) TestTradeGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	require.Equal(items, k.GetAllTrade(ctx))
}

func (suite *IntegrationTestSuite) TestTradeListByCreator() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTradeSameOwner(k, ctx, 10)
	addr, err := sdk.AccAddressFromBech32(items[0].Creator)
	require.NoError(err)

	// create more items with different creators
	items2 := createNTrade(k, ctx, 10)
	items = append(items, items2[0])

	trades, _, err := k.GetTradesByCreatorPaginated(ctx, addr, nil)
	require.NoError(err)

	require.Equal(items, trades)
}

func (suite *IntegrationTestSuite) TestTradeCount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNTrade(k, ctx, 10)
	count := uint64(len(items))
	require.Equal(count, k.GetTradeCount(ctx))
}

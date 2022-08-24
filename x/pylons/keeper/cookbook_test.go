package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestCookbookGet() {
	// k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNCookbook(k, ctx, 10)
	for _, item := range items {
		rst, found := k.GetCookbook(ctx, item.Id)
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

func (suite *IntegrationTestSuite) TestUpdateCookbook() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	creators := types.GenTestBech32List(1)
	cookBook := types.Cookbook{
		Creator: creators[0],
		Id:      "UpdateId",
	}

	items := createNCookbook(k, ctx, 1)
	require.Equal(items, k.GetAllCookbook(ctx))

	addr, _ := sdk.AccAddressFromBech32(items[0].Creator)

	k.UpdateCookbook(ctx, cookBook, addr)
	cb, found := k.GetCookbook(ctx, cookBook.Id)
	require.True(found)
	require.Equal(cb, cookBook)
	require.NotEqual(cb, items[0])
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

package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNCookbook(k keeper.Keeper, ctx sdk.Context, n int) []types.Cookbook {
	items := make([]types.Cookbook, n)
	creators := CreateTestFakeAddressList(uint(n))
	for i := range items {
		items[i].Creator = creators[i]
		items[i].ID = fmt.Sprintf("%d", i)
		items[i].CostPerBlock = sdk.NewCoin("test", sdk.NewInt(1))
		k.SetCookbook(ctx, items[i])
	}
	return items
}

func (suite *IntegrationTestSuite) TestCookbookGet() {
	//k, ctx := setupKeeper(t)
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
	//k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNCookbook(k, ctx, 10)
	require.Equal(items, k.GetAllCookbook(ctx))
}

func (suite *IntegrationTestSuite) TestCookbookGetAllByCreator() {
	//k, ctx := setupKeeper(t)
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNCookbook(k, ctx, 10)
	for _, item := range items {
		rst := k.GetAllCookbookByCreator(ctx, item.Creator)
		require.Equal(item, rst[0])
	}
}

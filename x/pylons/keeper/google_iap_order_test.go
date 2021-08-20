package keeper_test

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func createNGoogleIAPOrder(k *keeper.Keeper, ctx sdk.Context, n int) []types.GoogleInAppPurchaseOrder {
	items := make([]types.GoogleInAppPurchaseOrder, n)
	for i := range items {
		items[i].Creator = "any"
		items[i].PurchaseToken = strconv.Itoa(int(i))
		k.AppendGoogleIAPOrder(ctx, items[i])
	}
	return items
}

func (suite *IntegrationTestSuite) TestGoogleIAPOrderGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNGoogleIAPOrder(&k, ctx, 10)
	for _, item := range items {
		require.Equal(item, k.GetGoogleIAPOrder(ctx, item.PurchaseToken))
	}
}

func (suite *IntegrationTestSuite) TestGoogleIAPOrderExist() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNGoogleIAPOrder(&k, ctx, 10)
	for _, item := range items {
		require.True(k.HasGoogleIAPOrder(ctx, item.PurchaseToken))
	}
}

func (suite *IntegrationTestSuite) TestGoogleIAPOrderGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNGoogleIAPOrder(&k, ctx, 10)
	require.Equal(items, k.GetAllGoogleIAPOrder(ctx))
	require.Equal(items, k.GetAllGoogleIAPOrder(ctx))
}

func (suite *IntegrationTestSuite) TestGoogleIAPOrderCount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNGoogleIAPOrder(&k, ctx, 10)
	count := uint64(len(items))
	require.Equal(count, k.GetGoogleIAPOrderCount(ctx))
}

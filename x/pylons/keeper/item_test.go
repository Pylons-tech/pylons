package keeper_test

import (
	"fmt"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func createNItem(k *keeper.Keeper, ctx sdk.Context, n int) []types.Item {
	items := make([]types.Item, n)
	coin := sdk.NewCoin("test", sdk.NewInt(1))
	for i := range items {
		items[i].Owner = "any"
		items[i].CookbookID = fmt.Sprintf("%d", i)
		items[i].ID = types.EncodeItemID(uint64(i))
		items[i].TransferFee = coin
		k.SetItem(ctx, items[i])
	}
	return items
}

func (suite *IntegrationTestSuite)  TestItemGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNItem(&k, ctx, 10)
	for _, item := range items {
		rst, found := k.GetItem(ctx, item.CookbookID, item.ID)
		require.True(found)
		require.Equal(item, rst)
	}
}

func (suite *IntegrationTestSuite)  TestItemGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNItem(&k, ctx, 10)
	require.Equal(items, k.GetAllItem(ctx))
}

package keeper_test

import (
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNCookbook(k *keeper.Keeper, ctx sdk.Context, n int) []types.Cookbook {
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

func TestCookbookGet(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNCookbook(&k, ctx, 10)
	for _, item := range items {
		rst, found := k.GetCookbook(ctx, item.ID)
		assert.True(t, found)
		assert.Equal(t, item, rst)
	}
}

func TestCookbookGetAll(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNCookbook(&k, ctx, 10)
	assert.Equal(t, items, k.GetAllCookbook(ctx))
}

func TestCookbookGetAllByCreator(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNCookbook(&k, ctx, 10)
	for _, item := range items {
		rst := k.GetAllCookbookByCreator(ctx, item.Creator)
		assert.Equal(t, item, rst[0])
	}
}

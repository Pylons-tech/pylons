package keeper

import (
	"fmt"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNItem(keeper *Keeper, ctx sdk.Context, n int) []types.Item {
	items := make([]types.Item, n)
	for i := range items {
		items[i].Creator = "any"
		items[i].ID = fmt.Sprintf("%d", i)
		keeper.SetItem(ctx, items[i])
	}
	return items
}

func TestItemGet(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNItem(keeper, ctx, 10)
	for _, item := range items {
		rst, found := keeper.GetItem(ctx, item.ID)
		assert.True(t, found)
		assert.Equal(t, item, rst)
	}
}
func TestItemRemove(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNItem(keeper, ctx, 10)
	for _, item := range items {
		keeper.RemoveItem(ctx, item.ID)
		_, found := keeper.GetItem(ctx, item.ID)
		assert.False(t, found)
	}
}

func TestItemGetAll(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNItem(keeper, ctx, 10)
	assert.Equal(t, items, keeper.GetAllItem(ctx))
}

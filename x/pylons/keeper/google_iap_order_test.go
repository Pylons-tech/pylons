package keeper

import (
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"
)

func createNGoogleIAPOrder(keeper *Keeper, ctx sdk.Context, n int) []types.GoogleIAPOrder {
	items := make([]types.GoogleIAPOrder, n)
	for i := range items {
		items[i].Creator = "any"
		items[i].Id = keeper.AppendGoogleIAPOrder(ctx, items[i])
	}
	return items
}

func TestGoogleIAPOrderGet(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&keeper, ctx, 10)
	for _, item := range items {
		assert.Equal(t, item, keeper.GetGoogleIAPOrder(ctx, item.Id))
	}
}

func TestGooglIAPOrderExist(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&keeper, ctx, 10)
	for _, item := range items {
		assert.True(t, keeper.HasGoogleIAPOrder(ctx, item.Id))
	}
}

func TestGooglIAPOrderRemove(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&keeper, ctx, 10)
	for _, item := range items {
		keeper.RemoveGoogleIAPOrder(ctx, item.Id)
		assert.False(t, keeper.HasGoogleIAPOrder(ctx, item.Id))
	}
}

func TestGooglIAPOrderGetAll(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&keeper, ctx, 10)
	assert.Equal(t, items, keeper.GetAllGoogleIAPOrder(ctx))
}

func TestGooglIAPOrderCount(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&keeper, ctx, 10)
	count := uint64(len(items))
	assert.Equal(t, count, keeper.GetGoogleIAPOrderCount(ctx))
}

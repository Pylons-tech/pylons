package keeper

import (
	"strconv"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNGoogleIAPOrder(keeper *Keeper, ctx sdk.Context, n int) []types.GoogleIAPOrder {
	items := make([]types.GoogleIAPOrder, n)
	var count uint64
	for i := range items {
		items[i].Creator = "any"
		items[i].PurchaseToken = strconv.Itoa(int(count))
		count = keeper.AppendGoogleIAPOrder(ctx, items[i])
	}
	return items
}

func TestGoogleIAPOrderGet(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&keeper, ctx, 10)
	for _, item := range items {
		assert.Equal(t, item, keeper.GetGoogleIAPOrder(ctx, item.PurchaseToken))
	}
}

func TestGooglIAPOrderExist(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&keeper, ctx, 10)
	for _, item := range items {
		assert.True(t, keeper.HasGoogleIAPOrder(ctx, item.PurchaseToken))
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

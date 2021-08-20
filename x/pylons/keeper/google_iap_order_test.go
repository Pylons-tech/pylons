package keeper_test

import (
	"strconv"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
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

func TestGoogleIAPOrderGet(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&k, ctx, 10)
	for _, item := range items {
		assert.Equal(t, item, k.GetGoogleIAPOrder(ctx, item.PurchaseToken))
	}
}

func TestGoogleIAPOrderExist(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&k, ctx, 10)
	for _, item := range items {
		assert.True(t, k.HasGoogleIAPOrder(ctx, item.PurchaseToken))
	}
}

func TestGoogleIAPOrderGetAll(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&k, ctx, 10)
	assert.Equal(t, items, k.GetAllGoogleIAPOrder(ctx))
}

func TestGoogleIAPOrderCount(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNGoogleIAPOrder(&k, ctx, 10)
	count := uint64(len(items))
	assert.Equal(t, count, k.GetGoogleIAPOrderCount(ctx))
}

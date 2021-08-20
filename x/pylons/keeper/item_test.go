package keeper_test

import (
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
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

func TestItemGet(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNItem(&k, ctx, 10)
	for _, item := range items {
		rst, found := k.GetItem(ctx, item.CookbookID, item.ID)
		assert.True(t, found)
		assert.Equal(t, item, rst)
	}
}

func TestItemGetAll(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNItem(&k, ctx, 10)
	assert.Equal(t, items, k.GetAllItem(ctx))
}

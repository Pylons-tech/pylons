package keeper

import (
	"fmt"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNItem(k *Keeper, ctx sdk.Context, n int) []types.Item {
	items := make([]types.Item, n)
	for i := range items {
		items[i].Creator = "any"
		items[i].CookbookID = fmt.Sprintf("%d", i)
		items[i].RecipeID = fmt.Sprintf("%d", i)
		items[i].ID = fmt.Sprintf("%d", i)
		k.SetItem(ctx, items[i])
	}
	return items
}

func TestItemGet(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNItem(keeper, ctx, 10)
	for _, item := range items {
		rst, found := keeper.GetItem(ctx, item.CookbookID, item.RecipeID, item.ID)
		assert.True(t, found)
		assert.Equal(t, item, rst)
	}
}

func TestItemGetAll(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNItem(keeper, ctx, 10)
	assert.Equal(t, items, keeper.GetAllItem(ctx))
}

package keeper_test

import (
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNRecipe(k *keeper.Keeper, ctx sdk.Context, cb types.Cookbook, n int) []types.Recipe {
	items := make([]types.Recipe, n)
	for i := range items {
		items[i].CookbookID = cb.ID
		items[i].ID = fmt.Sprintf("%d", i)
		k.SetRecipe(ctx, items[i])
	}
	return items
}

func TestRecipeGet(t *testing.T) {
	k, ctx := setupKeeper(t)
	cookbooks := createNCookbook(&k, ctx, 1)
	items := createNRecipe(&k, ctx, cookbooks[0], 10)
	for _, item := range items {
		rst, found := k.GetRecipe(ctx, cookbooks[0].ID, item.ID)
		assert.True(t, found)
		assert.Equal(t, item, rst)
	}
}

func TestRecipeGetAll(t *testing.T) {
	k, ctx := setupKeeper(t)
	cookbooks := createNCookbook(&k, ctx, 1)
	items := createNRecipe(&k, ctx, cookbooks[0], 10)
	assert.Equal(t, items, k.GetAllRecipe(ctx))
}

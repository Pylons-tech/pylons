package keeper

import (
	"fmt"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNRecipe(keeper *Keeper, ctx sdk.Context, n int) []types.Recipe {
	items := make([]types.Recipe, n)
	for i := range items {
		items[i].CookbookID = fmt.Sprintf("%d", i)
		items[i].Index = fmt.Sprintf("%d", i)
		keeper.SetRecipe(ctx, items[i])
	}
	return items
}

func TestRecipeGet(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNRecipe(keeper, ctx, 10)
	for _, item := range items {
		rst, found := keeper.GetRecipe(ctx, item.Index)
		assert.True(t, found)
		assert.Equal(t, item, rst)
	}
}

func TestRecipeGetAll(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNRecipe(keeper, ctx, 10)
	assert.Equal(t, items, keeper.GetAllRecipe(ctx))
}

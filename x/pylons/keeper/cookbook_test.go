package keeper

import (
	"fmt"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNCookbook(keeper *Keeper, ctx sdk.Context, n int) []types.Cookbook {
	items := make([]types.Cookbook, n)
	creators := CreateTestAccounts(uint(n))
	for i := range items {
		items[i].Creator = creators[i]
		items[i].ID = fmt.Sprintf("%d", i)
		keeper.SetCookbook(ctx, items[i])
	}
	return items
}

func TestCookbookGet(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNCookbook(keeper, ctx, 10)
	for _, item := range items {
		rst, found := keeper.GetCookbook(ctx, item.ID)
		assert.True(t, found)
		assert.Equal(t, item, rst)
	}
}

func TestCookbookGetAll(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNCookbook(keeper, ctx, 10)
	assert.Equal(t, items, keeper.GetAllCookbook(ctx))
}

func TestCookbookGetAllByCreator(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNCookbook(keeper, ctx, 10)
	for _, item := range items {
		rst := keeper.GetAllCookbookByCreator(ctx, item.Creator)
		assert.Equal(t, item, rst[0])
	}
}

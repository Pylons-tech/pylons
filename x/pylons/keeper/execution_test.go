package keeper

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNExecution(keeper *Keeper, ctx sdk.Context, n int) []types.Execution {
	items := make([]types.Execution, n)
	for i := range items {
		items[i].Creator = "any"
		items[i].Id = uint64(i)
		keeper.appendExecution(ctx, items[i])
	}
	return items
}

func TestExecutionGet(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNExecution(keeper, ctx, 10)
	for _, item := range items {
		assert.Equal(t, item, keeper.GetExecution(ctx, item.Id))
	}
}

func TestExecutionExist(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNExecution(keeper, ctx, 10)
	for _, item := range items {
		assert.True(t, keeper.HasExecution(ctx, item.Id))
	}
}

func TestActualizeExecution(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	pending := createNPendingExecution(keeper, ctx, 1)
	keeper.ActualizeExecution(ctx, pending[0])
	assert.Empty(t, keeper.GetPendingExecution(ctx, pending[0].Id))
	assert.Equal(t, pending[0], keeper.GetExecution(ctx, pending[0].Id))
}

func TestExecutionGetAll(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNExecution(keeper, ctx, 10)
	assert.Equal(t, items, keeper.GetAllExecution(ctx))
}

func TestExecutionCount(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNExecution(keeper, ctx, 10)
	count := uint64(len(items))
	assert.Equal(t, count, keeper.GetExecutionCount(ctx))
}

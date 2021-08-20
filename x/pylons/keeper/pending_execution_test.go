package keeper_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNPendingExecution(k *keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	items := make([]types.Execution, n)
	for i := range items {
		items[i].Creator = "any"
		items[i].ID = k.AppendPendingExecution(ctx, items[i], 0)
	}
	return items
}

func TestPendingExecutionGet(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNPendingExecution(&k, ctx, 10)
	for _, item := range items {
		assert.Equal(t, item, k.GetPendingExecution(ctx, item.ID))
	}
}

func TestPendingExecutionExist(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNPendingExecution(&k, ctx, 10)
	for _, item := range items {
		assert.True(t, k.HasPendingExecution(ctx, item.ID))
	}
}

func TestPendingExecutionGetAll(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNPendingExecution(&k, ctx, 10)
	assert.Equal(t, items, k.GetAllPendingExecution(ctx))
}

func TestPendingExecutionCount(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNPendingExecution(&k, ctx, 10)
	count := uint64(len(items))
	assert.Equal(t, count, k.GetPendingExecutionCount(ctx))
}

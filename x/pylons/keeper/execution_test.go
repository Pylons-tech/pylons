package keeper

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNExecution(k *Keeper, ctx sdk.Context, n int) []types.Execution {
	execs := make([]types.Execution, n)
	for i := range items {
		execs[i].Creator = "any"
		execs[i].Id = uint64(i)
		k.appendExecution(ctx, execs[i])
	}
	return execs
}

func createNExecutionForSingleItem(k *Keeper, ctx sdk.Context, n int) types.Execution {
	exec := types.Execution{
		RecipeID:   "testRecipeID",
		CookbookID: "testCookbookID",
		// TODO fill fields
		ItemInputs:    nil,
		ItemOutputIDs: nil,
	}
	for i := 0; i < n; i++ {
		exec.Creator = Sprintf("any%v", i) // ok if different people ran executions
		exec.ID = uint64(i)
		k.appendExecution(ctx, exec)
	}
	return item
}

func TestExecutionGet(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	items := createNExecution(keeper, ctx, 10)
	for _, item := range items {
		assert.Equal(t, item, keeper.GetExecution(ctx, item.Id))
	}
}

// TODO verify
func TestExecutionsGetByItem(t *testing.T) {
	numExecs := 10
	keeper, ctx := setupKeeper(t)
	itemExec := createNExecutionForSingleItem(keeper, ctx, numExecs)
	execs := keeper.GetExecutionsByItem(ctx, itemExec.CookbookID, itemExec.RecipeID, itemExec.ID)
	assert.Equal(t, numExecs, len(execs))
	for _, exec := range execs {
		assert.Equal(t, exec.CookbookID, itemExec.CookbookID)
		assert.Equal(t, exec.RecipeID, itemExec.RecipeID)
		assert.Equal(t, exec.ID, itemExec.Id)

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

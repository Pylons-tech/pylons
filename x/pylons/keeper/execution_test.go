package keeper_test

import (
	"fmt"
	"strconv"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNExecution(k *keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	execs := make([]types.Execution, n)
	for i := range execs {
		execs[i].Creator = "any"
		execs[i].ID = strconv.Itoa(i)
		//k.appendExecution(ctx, execs[i])
		k.SetExecution(ctx, execs[i])
	}
	return execs
}

func createNExecutionForSingleItem(k *keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	exec := types.Execution{
		ItemInputs: []types.ItemRecord{
			{
				ID: "test1",
			},
		},
		ItemOutputIDs: []string{"test1"},
		Recipe:        types.Recipe{CookbookID: "testCookbookID", ID: "testRecipeID"},
	}

	execs := make([]types.Execution, n)

	for i := range execs {
		execs[i] = exec
		execs[i].Creator = fmt.Sprintf("any%v", i) // ok if different people ran executions
		execs[i].ID = strconv.Itoa(i)
		//k.appendExecution(ctx, execs[i])
		k.SetExecution(ctx, execs[i])

	}

	return execs
}

func TestExecutionGet(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNExecution(&k, ctx, 10)
	for _, item := range items {
		assert.Equal(t, item, k.GetExecution(ctx, item.ID))
	}
}

// TODO verify and add more test cases
func TestExecutionsGetByItem(t *testing.T) {
	numExecs := 10
	k, ctx := setupKeeper(t)
	itemExecs := createNExecutionForSingleItem(&k, ctx, numExecs)
	itemCookbookID := itemExecs[0].Recipe.CookbookID
	itemItemID := itemExecs[0].ItemOutputIDs[0]

	execs := k.GetExecutionsByItem(ctx, itemCookbookID, itemItemID)
	assert.Equal(t, numExecs, len(itemExecs))
	assert.Equal(t, numExecs, len(execs))
	for i, exec := range execs {
		assert.Equal(t, exec.Recipe.CookbookID, itemCookbookID)
		assert.Equal(t, exec.ID, itemExecs[i].ID)
	}
}

// TODO verify and add more test cases
func TestExecutionsGetByRecipe(t *testing.T) {
	numExecs := 10
	k, ctx := setupKeeper(t)
	itemExecs := createNExecutionForSingleItem(&k, ctx, numExecs)
	itemCookbookID := itemExecs[0].Recipe.CookbookID
	recipeID := itemExecs[0].Recipe.ID

	execs := k.GetExecutionsByRecipe(ctx, itemCookbookID, recipeID)
	assert.Equal(t, numExecs, len(itemExecs))
	assert.Equal(t, numExecs, len(execs))
	for i, exec := range execs {
		assert.Equal(t, exec.Recipe.CookbookID, itemCookbookID)
		assert.Equal(t, exec.ID, itemExecs[i].ID)
	}
}

func TestExecutionExist(t *testing.T) {
	k, ctx := setupKeeper(t)
	items := createNExecution(&k, ctx, 10)
	for _, item := range items {
		assert.True(t, k.HasExecution(ctx, item.ID))
	}
}

func TestActualizeExecution(t *testing.T) {
	k, ctx := setupKeeper(t)
	pending := createNPendingExecution(&k, ctx, 1)
	k.ActualizeExecution(ctx, pending[0])
	assert.Empty(t, k.GetPendingExecution(ctx, pending[0].ID))
	assert.Equal(t, pending[0], k.GetExecution(ctx, pending[0].ID))
}

func TestExecutionGetAll(t *testing.T) {
	k, ctx := setupKeeper(t)
	execs := createNExecution(&k, ctx, 10)
	assert.Equal(t, execs, k.GetAllExecution(ctx))
}

func TestExecutionCount(t *testing.T) {
	k, ctx := setupKeeper(t)
	execs := createNExecution(&k, ctx, 10)
	count := uint64(len(execs))
	assert.Equal(t, count, k.GetExecutionCount(ctx))
}

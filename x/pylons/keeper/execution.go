package keeper

import (
	"strconv"

	"github.com/cosmos/cosmos-sdk/types/query"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetExecutionCount get the total number of TypeName.LowerCamel
func (k Keeper) GetExecutionCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionCountKey))
	byteKey := types.KeyPrefix(types.ExecutionCountKey)
	bz := store.Get(byteKey)

	// Count doesn't exist: no element
	if bz == nil {
		return 0
	}

	// Parse bytes
	count, err := strconv.ParseUint(string(bz), 10, 64)
	if err != nil {
		// Panic because the count should be always formattable to uint64
		panic("cannot decode count")
	}

	return count
}

// SetExecutionCount set the total number of execution
func (k Keeper) SetExecutionCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionCountKey))
	byteKey := types.KeyPrefix(types.ExecutionCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// setExecutionByRecipe maps adds the execution to the store that maps executions on recipes
func (k Keeper) setExecutionByRecipe(ctx sdk.Context, execution types.Execution) {
	recpExecStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RecipeExecutionKey))
	recpExecStore = prefix.NewStore(recpExecStore, types.KeyPrefix(execution.CookbookID))
	recpExecStore = prefix.NewStore(recpExecStore, types.KeyPrefix(execution.RecipeID))
	byteKey := types.KeyPrefix(execution.ID)
	bz := []byte(execution.ID)
	recpExecStore.Set(byteKey, bz)
}

// GetExecutionsByRecipe returns paginated completed and pending Executions of the specified RecipeID
func (k Keeper) getExecutionsByRecipePaginated(ctx sdk.Context, cookbookID, recipeID string, pagination *query.PageRequest) ([]types.Execution, []types.Execution, *query.PageResponse, error) {
	completedExecutions := make([]types.Execution, 0)
	pendingExecutions := make([]types.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RecipeExecutionKey))
	store = prefix.NewStore(store, types.KeyPrefix(cookbookID))
	store = prefix.NewStore(store, types.KeyPrefix(recipeID))

	pageRes, err := query.Paginate(store, pagination, func(_, value []byte) error {
		id := string(value)
		if k.HasPendingExecution(ctx, id) {
			execution := k.GetPendingExecution(ctx, id)
			pendingExecutions = append(pendingExecutions, execution)
		} else {
			execution := k.GetExecution(ctx, id)
			completedExecutions = append(completedExecutions, execution)
		}
		return nil
	})

	if err != nil {
		return nil, nil, nil, err
	}

	return completedExecutions, pendingExecutions, pageRes, nil
}

// GetAllExecutionByRecipe returns completed and pending Executions of the specified RecipeID
func (k Keeper) GetAllExecutionByRecipe(ctx sdk.Context, cookbookID, recipeID string) ([]types.Execution, []types.Execution) {
	completedExecutions := make([]types.Execution, 0)
	pendingExecutions := make([]types.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RecipeExecutionKey))
	store = prefix.NewStore(store, types.KeyPrefix(cookbookID))
	iterator := sdk.KVStorePrefixIterator(store, types.KeyPrefix(recipeID))

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		id := string(iterator.Value())
		if k.HasPendingExecution(ctx, id) {
			execution := k.GetPendingExecution(ctx, id)
			pendingExecutions = append(pendingExecutions, execution)
		} else {
			execution := k.GetExecution(ctx, id)
			completedExecutions = append(completedExecutions, execution)
		}
	}

	return completedExecutions, pendingExecutions
}

// setExecutionByItem maps adds the execution to the store that maps executions on items
func (k Keeper) setExecutionByItem(ctx sdk.Context, execution types.Execution) {
	itemExecStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemExecutionKey))
	itemExecStore = prefix.NewStore(itemExecStore, types.KeyPrefix(execution.CookbookID))
	for _, itemOutputID := range execution.ItemOutputIDs {
		itemExecStore = prefix.NewStore(itemExecStore, types.KeyPrefix(itemOutputID))
		byteKey := types.KeyPrefix(execution.ID)
		bz := []byte(execution.ID)
		itemExecStore.Set(byteKey, bz)
	}
	for _, itemModifyOutputID := range execution.ItemModifyOutputIDs {
		itemExecStore = prefix.NewStore(itemExecStore, types.KeyPrefix(itemModifyOutputID))
		byteKey := types.KeyPrefix(execution.ID)
		bz := []byte(execution.ID)
		itemExecStore.Set(byteKey, bz)
	}
}

// getExecutionsByItemPaginated returns paginated completed and pending Executions of the specified itemID
func (k Keeper) getExecutionsByItemPaginated(ctx sdk.Context, cookbookID, itemID string, pagination *query.PageRequest) ([]types.Execution, []types.Execution, *query.PageResponse, error) {
	completedExecutions := make([]types.Execution, 0)
	pendingExecutions := make([]types.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemExecutionKey))
	store = prefix.NewStore(store, types.KeyPrefix(cookbookID))
	store = prefix.NewStore(store, types.KeyPrefix(itemID))

	pageRes, err := query.Paginate(store, pagination, func(_, value []byte) error {
		id := string(value)
		if k.HasPendingExecution(ctx, id) {
			execution := k.GetPendingExecution(ctx, id)
			pendingExecutions = append(pendingExecutions, execution)
		} else {
			execution := k.GetExecution(ctx, id)
			completedExecutions = append(completedExecutions, execution)
		}
		return nil
	})

	if err != nil {
		return nil, nil, nil, err
	}

	return completedExecutions, pendingExecutions, pageRes, nil
}

func (k Keeper) getCompletedExecutionsByItem(ctx sdk.Context, cookbookID, itemID string) []types.Execution {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemExecutionKey))
	store = prefix.NewStore(store, types.KeyPrefix(cookbookID))
	iterator := sdk.KVStorePrefixIterator(store, types.KeyPrefix(itemID))

	defer iterator.Close()

	res := make([]types.Execution, 0)
	for ; iterator.Valid(); iterator.Next() {
		var val types.Execution
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		res = append(res, val)
	}

	return res
}

// GetAllExecutionByItem returns completed and pending Executions of the specified itemID
func (k Keeper) GetAllExecutionByItem(ctx sdk.Context, cookbookID, itemID string) ([]types.Execution, []types.Execution) {
	completedExecutions := make([]types.Execution, 0)
	pendingExecutions := make([]types.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemExecutionKey))
	store = prefix.NewStore(store, types.KeyPrefix(cookbookID))
	iterator := sdk.KVStorePrefixIterator(store, types.KeyPrefix(itemID))

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		id := string(iterator.Value())
		if k.HasPendingExecution(ctx, id) {
			execution := k.GetPendingExecution(ctx, id)
			pendingExecutions = append(pendingExecutions, execution)
		} else {
			execution := k.GetExecution(ctx, id)
			completedExecutions = append(completedExecutions, execution)
		}
	}

	return completedExecutions, pendingExecutions
}

// ActualizeExecution removes a pending execution and moves it to the execution store
func (k Keeper) ActualizeExecution(ctx sdk.Context, execution types.Execution) {
	k.removePendingExecution(ctx, execution.ID)
	k.appendExecution(ctx, execution)
}

// appendExecution appends an execution in the store and updates the count
func (k Keeper) appendExecution(ctx sdk.Context, execution types.Execution) {
	// Create the execution
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	appendedValue := k.cdc.MustMarshal(&execution)
	store.Set(types.KeyPrefix(execution.ID), appendedValue)

	// Update execution count
	count := k.GetExecutionCount(ctx)
	k.SetExecutionCount(ctx, count+1)
}

// GetExecution returns an execution from its id
func (k Keeper) GetExecution(ctx sdk.Context, id string) types.Execution {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	var execution types.Execution
	k.cdc.MustUnmarshal(store.Get(types.KeyPrefix(id)), &execution)
	return execution
}

// SetExecution sets an execution in the store
func (k Keeper) SetExecution(ctx sdk.Context, execution types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	value := k.cdc.MustMarshal(&execution)
	store.Set(types.KeyPrefix(execution.ID), value)

	// add execution to recipe mapping
	k.setExecutionByRecipe(ctx, execution)
	// add execution to item mapping
	k.setExecutionByItem(ctx, execution)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// HasExecution checks if the execution exists in the store
func (k Keeper) HasExecution(ctx sdk.Context, id string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	return store.Has(types.KeyPrefix(id))
}

// GetAllExecution returns all execution
func (k Keeper) GetAllExecution(ctx sdk.Context) (list []types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Execution
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

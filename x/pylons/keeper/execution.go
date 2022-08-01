package keeper

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/types/query"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// GetExecutionCount get the total number of TypeName.LowerCamel
func (k Keeper) GetExecutionCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ExecutionCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.ExecutionCountKey)
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
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ExecutionCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.ExecutionCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// setExecutionByRecipe maps adds the execution to the store that maps executions on recipes
func (k Keeper) setExecutionByRecipe(ctx sdk.Context, execution v1beta1.Execution) {
	recpExecStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.RecipeExecutionKey))
	recpExecStore = prefix.NewStore(recpExecStore, v1beta1.KeyPrefix(execution.CookbookId))
	recpExecStore = prefix.NewStore(recpExecStore, v1beta1.KeyPrefix(execution.RecipeId))
	byteKey := v1beta1.KeyPrefix(execution.Id)
	bz := []byte(execution.Id)
	recpExecStore.Set(byteKey, bz)
}

// GetExecutionsByRecipe returns paginated completed and pending Executions of the specified RecipeID
func (k Keeper) getExecutionsByRecipePaginated(ctx sdk.Context, cookbookID, recipeID string, pagination *query.PageRequest) ([]v1beta1.Execution, []v1beta1.Execution, *query.PageResponse, error) {
	completedExecutions := make([]v1beta1.Execution, 0)
	pendingExecutions := make([]v1beta1.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.RecipeExecutionKey))
	store = prefix.NewStore(store, v1beta1.KeyPrefix(cookbookID))
	store = prefix.NewStore(store, v1beta1.KeyPrefix(recipeID))

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
func (k Keeper) GetAllExecutionByRecipe(ctx sdk.Context, cookbookID, recipeID string) ([]v1beta1.Execution, []v1beta1.Execution) {
	completedExecutions := make([]v1beta1.Execution, 0)
	pendingExecutions := make([]v1beta1.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.RecipeExecutionKey))
	store = prefix.NewStore(store, v1beta1.KeyPrefix(cookbookID))
	iterator := sdk.KVStorePrefixIterator(store, v1beta1.KeyPrefix(recipeID))

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
func (k Keeper) setExecutionByItem(ctx sdk.Context, execution v1beta1.Execution) {
	itemExecStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemExecutionKey))
	itemExecStore = prefix.NewStore(itemExecStore, v1beta1.KeyPrefix(execution.CookbookId))
	for _, itemOutputID := range execution.ItemOutputIds {
		itemExecStore = prefix.NewStore(itemExecStore, v1beta1.KeyPrefix(itemOutputID))
		byteKey := v1beta1.KeyPrefix(execution.Id)
		bz := []byte(execution.Id)
		itemExecStore.Set(byteKey, bz)
	}
	for _, itemModifyOutputID := range execution.ItemModifyOutputIds {
		itemExecStore = prefix.NewStore(itemExecStore, v1beta1.KeyPrefix(itemModifyOutputID))
		byteKey := v1beta1.KeyPrefix(execution.Id)
		bz := []byte(execution.Id)
		itemExecStore.Set(byteKey, bz)
	}
}

// getExecutionsByItemPaginated returns paginated completed and pending Executions of the specified itemID
func (k Keeper) getExecutionsByItemPaginated(ctx sdk.Context, cookbookID, itemID string, pagination *query.PageRequest) ([]v1beta1.Execution, []v1beta1.Execution, *query.PageResponse, error) {
	completedExecutions := make([]v1beta1.Execution, 0)
	pendingExecutions := make([]v1beta1.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemExecutionKey))
	store = prefix.NewStore(store, v1beta1.KeyPrefix(cookbookID))
	store = prefix.NewStore(store, v1beta1.KeyPrefix(itemID))

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

// GetAllExecutionByItem returns completed and pending Executions of the specified itemID
func (k Keeper) GetAllExecutionByItem(ctx sdk.Context, cookbookID, itemID string) ([]v1beta1.Execution, []v1beta1.Execution) {
	completedExecutions := make([]v1beta1.Execution, 0)
	pendingExecutions := make([]v1beta1.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemExecutionKey))
	store = prefix.NewStore(store, v1beta1.KeyPrefix(cookbookID))
	iterator := sdk.KVStorePrefixIterator(store, v1beta1.KeyPrefix(itemID))

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
func (k Keeper) ActualizeExecution(ctx sdk.Context, execution v1beta1.Execution) {
	k.removePendingExecution(ctx, execution.Id)
	k.appendExecution(ctx, execution)
}

// appendExecution appends an execution in the store and updates the count
func (k Keeper) appendExecution(ctx sdk.Context, execution v1beta1.Execution) {
	// Create the execution
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ExecutionKey))
	appendedValue := k.cdc.MustMarshal(&execution)
	store.Set(v1beta1.KeyPrefix(execution.Id), appendedValue)

	// Update execution count
	count := k.GetExecutionCount(ctx)
	k.SetExecutionCount(ctx, count+1)
}

// GetExecution returns an execution from its id
func (k Keeper) GetExecution(ctx sdk.Context, id string) v1beta1.Execution {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ExecutionKey))
	var execution v1beta1.Execution
	k.cdc.MustUnmarshal(store.Get(v1beta1.KeyPrefix(id)), &execution)
	return execution
}

// SetExecution sets an execution in the store
func (k Keeper) SetExecution(ctx sdk.Context, execution v1beta1.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ExecutionKey))
	value := k.cdc.MustMarshal(&execution)
	store.Set(v1beta1.KeyPrefix(execution.Id), value)

	// add execution to recipe mapping
	k.setExecutionByRecipe(ctx, execution)
	// add execution to item mapping
	k.setExecutionByItem(ctx, execution)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// HasExecution checks if the execution exists in the store
func (k Keeper) HasExecution(ctx sdk.Context, id string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ExecutionKey))
	return store.Has(v1beta1.KeyPrefix(id))
}

// GetAllExecution returns all execution
func (k Keeper) GetAllExecution(ctx sdk.Context) (list []v1beta1.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.Execution
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

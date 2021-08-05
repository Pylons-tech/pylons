package keeper

import (
	"encoding/binary"
	"strconv"

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

// GetExecutionsByItem returns a slice of Executions that relate to a given Item
func (k Keeper) GetExecutionsByItem(ctx sdk.Context, cookbookID, recipeID, itemID string) []types.Execution {
	executions := make([]types.Execution, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Execution
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)

		// if we match the item, append to list
		if val.CookbookID == cookbookID && val.RecipeID == recipeID {
			// TODO
			// CHECK the itemID
			executions = append(executions, val)
		}
	}

	return executions
}

// SetExecutionCount set the total number of execution
func (k Keeper) SetExecutionCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionCountKey))
	byteKey := types.KeyPrefix(types.ExecutionCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// ActualizeExecution removes a pending execution and moves it to the execution store
func (k Keeper) ActualizeExecution(ctx sdk.Context, execution types.Execution) {
	k.removePendingExecution(ctx, execution.Id)
	k.appendExecution(ctx, execution)
}

// AppendExecution appends an execution in the store with a new id and update the count
func (k Keeper) appendExecution(
	ctx sdk.Context,
	execution types.Execution,
) {
	// Create the execution
	count := k.GetExecutionCount(ctx)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	appendedValue := k.cdc.MustMarshalBinaryBare(&execution)
	store.Set(GetExecutionIDBytes(execution.Id), appendedValue)

	// Update execution count
	k.SetExecutionCount(ctx, count+1)
}

// GetExecution returns a execution from its id
func (k Keeper) GetExecution(ctx sdk.Context, id uint64) types.Execution {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	var execution types.Execution
	k.cdc.MustUnmarshalBinaryBare(store.Get(GetExecutionIDBytes(id)), &execution)
	return execution
}

// SetExecution sets an execution in the store
func (k Keeper) SetExecution(ctx sdk.Context, execution types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	value := k.cdc.MustMarshalBinaryBare(&execution)
	store.Set(GetExecutionIDBytes(execution.Id), value)
}

// HasExecution checks if the execution exists in the store
func (k Keeper) HasExecution(ctx sdk.Context, id uint64) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	return store.Has(GetExecutionIDBytes(id))
}

// GetAllExecution returns all execution
func (k Keeper) GetAllExecution(ctx sdk.Context) (list []types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Execution
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// GetExecutionIDBytes returns the byte representation of the ID
func GetExecutionIDBytes(id uint64) []byte {
	bz := make([]byte, 8)
	binary.BigEndian.PutUint64(bz, id)
	return bz
}

// GetExecutionIDFromBytes returns ID in uint64 format from a byte array
func GetExecutionIDFromBytes(bz []byte) uint64 {
	return binary.BigEndian.Uint64(bz)
}

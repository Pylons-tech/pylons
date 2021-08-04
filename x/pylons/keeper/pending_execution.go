package keeper

import (
	"strconv"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetPendingExecutionCount get the total number of TypeName.LowerCamel
func (k Keeper) GetPendingExecutionCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionCountKey))
	byteKey := types.KeyPrefix(types.PendingExecutionCountKey)
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

// SetPendingExecutionCount set the total number of pending executions
func (k Keeper) SetPendingExecutionCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionCountKey))
	byteKey := types.KeyPrefix(types.PendingExecutionCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendPendingExecution appends a execution in the store with a new id and update the count
func (k Keeper) AppendPendingExecution(
	ctx sdk.Context,
	execution types.Execution,
) uint64 {
	// Create the execution
	count := k.GetPendingExecutionCount(ctx)

	id := count + k.GetExecutionCount(ctx)
	// Set the ID of the appended value
	execution.Id = id

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	appendedValue := k.cdc.MustMarshalBinaryBare(&execution)
	store.Set(GetExecutionIDBytes(execution.Id), appendedValue)

	// Update execution count
	k.SetPendingExecutionCount(ctx, count+1)

	return count
}

// GetPendingExecution returns an execution from its id
func (k Keeper) GetPendingExecution(ctx sdk.Context, id uint64) types.Execution {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	var execution types.Execution
	k.cdc.MustUnmarshalBinaryBare(store.Get(GetExecutionIDBytes(id)), &execution)
	return execution
}

// SetPendingExecution sets a pending execution in the store
func (k Keeper) SetPendingExecution(ctx sdk.Context, execution types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	value := k.cdc.MustMarshalBinaryBare(&execution)
	store.Set(GetExecutionIDBytes(execution.Id), value)
}

// HasPendingExecution checks if the execution exists in the store
func (k Keeper) HasPendingExecution(ctx sdk.Context, id uint64) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	return store.Has(GetExecutionIDBytes(id))
}

// RemovePendingExecution removes an execution from the store
func (k Keeper) removePendingExecution(ctx sdk.Context, id uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	store.Delete(GetExecutionIDBytes(id))

	// Update pending execution count
	count := k.GetPendingExecutionCount(ctx)
	k.SetPendingExecutionCount(ctx, count-1)
}

// GetAllPendingExecution returns all execution
func (k Keeper) GetAllPendingExecution(ctx sdk.Context) (list []types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Execution
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

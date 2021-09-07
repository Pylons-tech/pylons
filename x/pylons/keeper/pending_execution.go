package keeper

import (
	"fmt"
	"strconv"
	"strings"

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

// AppendPendingExecution appends a pending execution in the store with a new id and update the count
func (k Keeper) AppendPendingExecution(ctx sdk.Context, execution types.Execution, blockInterval int64) string {
	// Create the execution
	count := k.GetPendingExecutionCount(ctx)

	// Target height is the block height where the pending execution
	// is actually able to be executed in the EndBlocker
	targetHeight := execution.BlockHeight + blockInterval
	id := fmt.Sprintf("%v-%v", targetHeight, count+k.GetExecutionCount(ctx))
	// Set the ID of the appended value
	execution.ID = id

	k.SetPendingExecution(ctx, execution)

	// Update execution count
	k.SetPendingExecutionCount(ctx, count+1)

	return id
}

// GetPendingExecution returns an execution from its id
func (k Keeper) GetPendingExecution(ctx sdk.Context, id string) types.Execution {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	var execution types.Execution
	k.cdc.MustUnmarshal(store.Get(types.KeyPrefix(id)), &execution)
	return execution
}

// SetPendingExecution sets a pending execution in the store
func (k Keeper) SetPendingExecution(ctx sdk.Context, execution types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	value := k.cdc.MustMarshal(&execution)
	store.Set(types.KeyPrefix(execution.ID), value)

	// add execution to recipe mapping
	k.setExecutionByRecipe(ctx, execution)
	// add execution to item mapping
	k.setExecutionByItem(ctx, execution)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// HasPendingExecution checks if the execution exists in the store
func (k Keeper) HasPendingExecution(ctx sdk.Context, id string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	return store.Has(types.KeyPrefix(id))
}

// RemovePendingExecution removes an execution from the store
func (k Keeper) removePendingExecution(ctx sdk.Context, id string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	store.Delete(types.KeyPrefix(id))

	// Update pending execution count
	count := k.GetPendingExecutionCount(ctx)
	k.SetPendingExecutionCount(ctx, count-1)
}

// UpdatePendingExecutionWithTargetBlockHeight updates a pendingExecution with a new ID
func (k Keeper) UpdatePendingExecutionWithTargetBlockHeight(ctx sdk.Context, execution types.Execution, blockHeight int64) string {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	store.Delete(types.KeyPrefix(execution.ID))

	idParts := strings.Split(execution.ID, "-")
	execution.ID = fmt.Sprintf("%v-%v", blockHeight, idParts[1])
	k.SetPendingExecution(ctx, execution)

	return execution.ID
}

// GetAllPendingExecution returns all execution
func (k Keeper) GetAllPendingExecution(ctx sdk.Context) (list []types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Execution
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// GetAllPendingExecutionAtBlockHeight returns all execution
func (k Keeper) GetAllPendingExecutionAtBlockHeight(ctx sdk.Context, blockHeight int64) (list []types.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PendingExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, types.KeyPrefix(fmt.Sprintf("%v-", blockHeight)))

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Execution
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

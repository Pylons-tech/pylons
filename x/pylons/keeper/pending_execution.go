package keeper

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// GetPendingExecutionCount get the total number of TypeName.LowerCamel
func (k Keeper) GetPendingExecutionCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.PendingExecutionCountKey)
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
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.PendingExecutionCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendPendingExecution appends a pending execution in the store with a new id and update the count
func (k Keeper) AppendPendingExecution(ctx sdk.Context, execution v1beta1.Execution, blockInterval int64) string {
	// Create the execution
	count := k.GetPendingExecutionCount(ctx)

	// Target height is the block height where the pending execution
	// is actually able to be executed in the EndBlocker
	targetHeight := execution.BlockHeight + blockInterval
	id := fmt.Sprintf("%v-%v", targetHeight, count+k.GetExecutionCount(ctx))
	// Set the ID of the appended value
	execution.Id = id

	k.SetPendingExecution(ctx, execution)

	// Update execution count
	k.SetPendingExecutionCount(ctx, count+1)

	return id
}

// GetPendingExecution returns an execution from its id
func (k Keeper) GetPendingExecution(ctx sdk.Context, id string) v1beta1.Execution {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionKey))
	var execution v1beta1.Execution
	k.cdc.MustUnmarshal(store.Get(v1beta1.KeyPrefix(id)), &execution)
	return execution
}

// SetPendingExecution sets a pending execution in the store
func (k Keeper) SetPendingExecution(ctx sdk.Context, execution v1beta1.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionKey))
	value := k.cdc.MustMarshal(&execution)
	store.Set(v1beta1.KeyPrefix(execution.Id), value)

	// add execution to recipe mapping
	k.setExecutionByRecipe(ctx, execution)
	// add execution to item mapping
	k.setExecutionByItem(ctx, execution)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// HasPendingExecution checks if the execution exists in the store
func (k Keeper) HasPendingExecution(ctx sdk.Context, id string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionKey))
	return store.Has(v1beta1.KeyPrefix(id))
}

// RemovePendingExecution removes an execution from the store
func (k Keeper) removePendingExecution(ctx sdk.Context, id string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionKey))
	store.Delete(v1beta1.KeyPrefix(id))

	// Update pending execution count
	count := k.GetPendingExecutionCount(ctx)
	k.SetPendingExecutionCount(ctx, count-1)
}

// UpdatePendingExecutionWithTargetBlockHeight updates a pendingExecution with a new ID
func (k Keeper) UpdatePendingExecutionWithTargetBlockHeight(ctx sdk.Context, execution v1beta1.Execution, blockHeight int64) string {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionKey))
	store.Delete(v1beta1.KeyPrefix(execution.Id))

	idParts := strings.Split(execution.Id, "-")
	execution.Id = fmt.Sprintf("%v-%v", blockHeight, idParts[1])
	k.SetPendingExecution(ctx, execution)

	return execution.Id
}

// GetAllPendingExecution returns all execution
func (k Keeper) GetAllPendingExecution(ctx sdk.Context) (list []v1beta1.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.Execution
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// GetAllPendingExecutionAtBlockHeight returns all execution
func (k Keeper) GetAllPendingExecutionAtBlockHeight(ctx sdk.Context, blockHeight int64) (list []v1beta1.Execution) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PendingExecutionKey))
	iterator := sdk.KVStorePrefixIterator(store, v1beta1.KeyPrefix(fmt.Sprintf("%v-", blockHeight)))

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.Execution
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

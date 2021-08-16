package keeper

import (
	"strconv"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetEntityCount get the total number of entities
func (k Keeper) GetEntityCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GlobalEntityCountKey))
	byteKey := types.KeyPrefix(types.GlobalEntityCountKey)
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

// SetEntityCount set the total number of entities
func (k Keeper) SetEntityCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GlobalEntityCountKey))
	byteKey := types.KeyPrefix(types.GlobalEntityCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

func (k Keeper) IncrementEntityCount(ctx sdk.Context) {
	count := k.GetEntityCount(ctx)
	count++

	k.SetEntityCount(ctx, count)
}

package keeper

import (
	"encoding/binary"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strconv"
)

// GetGoogleIAPOrderCount get the total number of TypeName.LowerCamel
func (k Keeper) GetGoogleIAPOrderCount(ctx sdk.Context) uint64 {
	store :=  prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderCountKey))
	byteKey := types.KeyPrefix(types.GoogleIAPOrderCountKey)
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

// SetGoogleIAPOrderCount set the total number of googlIAPOrder
func (k Keeper) SetGoogleIAPOrderCount(ctx sdk.Context, count uint64)  {
	store :=  prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderCountKey))
	byteKey := types.KeyPrefix(types.GoogleIAPOrderCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendGoogleIAPOrder appends a googlIAPOrder in the store with a new id and update the count
func (k Keeper) AppendGoogleIAPOrder(
    ctx sdk.Context,
    googleIAPOrder types.GoogleIAPOrder,
) uint64 {
	// Create the googleIAPOrder
    count := k.GetGoogleIAPOrderCount(ctx)

    // Set the ID of the appended value
    googleIAPOrder.Id = count

    store :=  prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderKey))
    appendedValue := k.cdc.MustMarshalBinaryBare(&googleIAPOrder)
    store.Set(GetGoogleIAPOrderIDBytes(googleIAPOrder.Id), appendedValue)

    // Update googleIAPOrder count
    k.SetGoogleIAPOrderCount(ctx, count+1)

    return count
}

// SetGoogleIAPOrder set a specific googlIAPOrder in the store
func (k Keeper) SetGoogleIAPOrder(ctx sdk.Context, googlIAPOrder types.GoogleIAPOrder) {
	store :=  prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderKey))
	b := k.cdc.MustMarshalBinaryBare(&googlIAPOrder)
	store.Set(GetGoogleIAPOrderIDBytes(googlIAPOrder.Id), b)
}

// GetGoogleIAPOrder returns a googlIAPOrder from its id
func (k Keeper) GetGoogleIAPOrder(ctx sdk.Context, id uint64) types.GoogleIAPOrder {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderKey))
	var googlIAPOrder types.GoogleIAPOrder
	k.cdc.MustUnmarshalBinaryBare(store.Get(GetGoogleIAPOrderIDBytes(id)), &googlIAPOrder)
	return googlIAPOrder
}

// HasGoogleIAPOrder checks if the googlIAPOrder exists in the store
func (k Keeper) HasGoogleIAPOrder(ctx sdk.Context, id uint64) bool {
	store :=  prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderKey))
	return store.Has(GetGoogleIAPOrderIDBytes(id))
}

// GetGoogleIAPOrderOwner returns the creator of the
func (k Keeper) GetGoogleIAPOrderOwner(ctx sdk.Context, id uint64) string {
    return k.GetGoogleIAPOrder(ctx, id).Creator
}

// RemoveGoogleIAPOrder removes a googlIAPOrder from the store
func (k Keeper) RemoveGoogleIAPOrder(ctx sdk.Context, id uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderKey))
	store.Delete(GetGoogleIAPOrderIDBytes(id))
}

// GetAllGoogleIAPOrder returns all googlIAPOrder
func (k Keeper) GetAllGoogleIAPOrder(ctx sdk.Context) (list []types.GoogleIAPOrder) {
    store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.GoogleIAPOrder
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
        list = append(list, val)
	}

    return
}

// GetGoogleIAPOrderIDBytes returns the byte representation of the ID
func GetGoogleIAPOrderIDBytes(id uint64) []byte {
	bz := make([]byte, 8)
	binary.BigEndian.PutUint64(bz, id)
	return bz
}

// GetGoogleIAPOrderIDFromBytes returns ID in uint64 format from a byte array
func GetGoogleIAPOrderIDFromBytes(bz []byte) uint64 {
	return binary.BigEndian.Uint64(bz)
}

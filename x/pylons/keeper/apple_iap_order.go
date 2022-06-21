package keeper

import (
	"strconv"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetAppleIAPOrderCount get the total number of TypeName.LowerCamel
func (k Keeper) GetAppleIAPOrderCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AppleInAppPurchaseOrderCountKey))
	byteKey := types.KeyPrefix(types.AppleInAppPurchaseOrderCountKey)
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

// SetAppleIAPOrderCount set the total number of googlIAPOrder
func (k Keeper) SetAppleIAPOrderCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AppleInAppPurchaseOrderCountKey))
	byteKey := types.KeyPrefix(types.AppleInAppPurchaseOrderCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendAppleIAPOrder appends a AppleIAPOrder in the store with a new id and update the count
func (k Keeper) AppendAppleIAPOrder(
	ctx sdk.Context,
	appleIAPOrder types.AppleInAppPurchaseOrder,
) uint64 {
	// Create the AppleIAPOrder
	count := k.GetAppleIAPOrderCount(ctx)

	k.SetAppleIAPOrder(ctx, appleIAPOrder)

	// Update AppleIAPOrder count
	k.SetAppleIAPOrderCount(ctx, count+1)

	return count
}

// SetAppleIAPOrder set a specific AppleIAPOrder in the store
func (k Keeper) SetAppleIAPOrder(ctx sdk.Context, appleIAPOrder types.AppleInAppPurchaseOrder) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AppleInAppPurchaseOrderKey))
	b := k.cdc.MustMarshal(&appleIAPOrder)
	store.Set(types.KeyPrefix(appleIAPOrder.TransactionID), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// GetAppleIAPOrder returns a AppleIAPOrder from its id
func (k Keeper) GetAppleIAPOrder(ctx sdk.Context, transactionID string) types.AppleInAppPurchaseOrder {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AppleInAppPurchaseOrderKey))
	var appleIAPOrder types.AppleInAppPurchaseOrder
	k.cdc.MustUnmarshal(store.Get(types.KeyPrefix(transactionID)), &appleIAPOrder)
	return appleIAPOrder
}

// HasAppleIAPOrder checks if the AppleIAPOrder exists in the store
func (k Keeper) HasAppleIAPOrder(ctx sdk.Context, transactionID string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AppleInAppPurchaseOrderKey))
	return store.Has(types.KeyPrefix(transactionID))
}

// GetAppleIAPOrderOwner returns the creator of the
func (k Keeper) GetAppleIAPOrderOwner(ctx sdk.Context, transactionID string) string {
	return k.GetAppleIAPOrder(ctx, transactionID).Creator
}

// GetAllAppleIAPOrder returns all AppleIAPOrder
func (k Keeper) GetAllAppleIAPOrder(ctx sdk.Context) (list []types.AppleInAppPurchaseOrder) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AppleInAppPurchaseOrderKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.AppleInAppPurchaseOrder
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

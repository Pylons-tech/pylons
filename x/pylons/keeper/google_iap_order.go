package keeper

import (
	"strconv"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetGoogleIAPOrderCount get the total number of TypeName.LowerCamel
func (k Keeper) GetGoogleIAPOrderCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderCountKey))
	byteKey := types.KeyPrefix(types.GoogleInAppPurchaseOrderCountKey)
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
func (k Keeper) SetGoogleIAPOrderCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderCountKey))
	byteKey := types.KeyPrefix(types.GoogleInAppPurchaseOrderCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// AppendGoogleIAPOrder appends a googleIAPOrder in the store with a new id and update the count
func (k Keeper) AppendGoogleIAPOrder(
	ctx sdk.Context,
	googleIAPOrder types.GoogleInAppPurchaseOrder,
) uint64 {
	// Create the googleIAPOrder
	count := k.GetGoogleIAPOrderCount(ctx)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	appendedValue := k.cdc.MustMarshalBinaryBare(&googleIAPOrder)
	store.Set(types.KeyPrefix(googleIAPOrder.PurchaseToken), appendedValue)

	// Update googleIAPOrder count
	k.SetGoogleIAPOrderCount(ctx, count+1)

	return count
}

// SetGoogleIAPOrder set a specific googleIAPOrder in the store
func (k Keeper) SetGoogleIAPOrder(ctx sdk.Context, googleIAPOrder types.GoogleInAppPurchaseOrder) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	b := k.cdc.MustMarshalBinaryBare(&googleIAPOrder)
	store.Set(types.KeyPrefix(googleIAPOrder.PurchaseToken), b)
}

// GetGoogleIAPOrder returns a googleIAPOrder from its id
func (k Keeper) GetGoogleIAPOrder(ctx sdk.Context, purchaseToken string) types.GoogleInAppPurchaseOrder {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	var googleIAPOrder types.GoogleInAppPurchaseOrder
	k.cdc.MustUnmarshalBinaryBare(store.Get(types.KeyPrefix(purchaseToken)), &googleIAPOrder)
	return googleIAPOrder
}

// HasGoogleIAPOrder checks if the googleIAPOrder exists in the store
func (k Keeper) HasGoogleIAPOrder(ctx sdk.Context, purchaseToken string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	return store.Has(types.KeyPrefix(purchaseToken))
}

// GetGoogleIAPOrderOwner returns the creator of the
func (k Keeper) GetGoogleIAPOrderOwner(ctx sdk.Context, purchaseToken string) string {
	return k.GetGoogleIAPOrder(ctx, purchaseToken).Creator
}

// GetAllGoogleIAPOrder returns all googleIAPOrder
func (k Keeper) GetAllGoogleIAPOrder(ctx sdk.Context) (list []types.GoogleInAppPurchaseOrder) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.GoogleInAppPurchaseOrder
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

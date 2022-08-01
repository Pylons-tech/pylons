package keeper

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// GetGoogleIAPOrderCount get the total number of TypeName.LowerCamel
func (k Keeper) GetGoogleIAPOrderCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderCountKey)
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
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendGoogleIAPOrder appends a googleIAPOrder in the store with a new id and update the count
func (k Keeper) AppendGoogleIAPOrder(
	ctx sdk.Context,
	googleIAPOrder v1beta1.GoogleInAppPurchaseOrder,
) uint64 {
	// Create the googleIAPOrder
	count := k.GetGoogleIAPOrderCount(ctx)

	k.SetGoogleIAPOrder(ctx, googleIAPOrder)

	// Update googleIAPOrder count
	k.SetGoogleIAPOrderCount(ctx, count+1)

	return count
}

// SetGoogleIAPOrder set a specific googleIAPOrder in the store
func (k Keeper) SetGoogleIAPOrder(ctx sdk.Context, googleIAPOrder v1beta1.GoogleInAppPurchaseOrder) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderKey))
	b := k.cdc.MustMarshal(&googleIAPOrder)
	store.Set(v1beta1.KeyPrefix(googleIAPOrder.PurchaseToken), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// GetGoogleIAPOrder returns a googleIAPOrder from its id
func (k Keeper) GetGoogleIAPOrder(ctx sdk.Context, purchaseToken string) v1beta1.GoogleInAppPurchaseOrder {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderKey))
	var googleIAPOrder v1beta1.GoogleInAppPurchaseOrder
	k.cdc.MustUnmarshal(store.Get(v1beta1.KeyPrefix(purchaseToken)), &googleIAPOrder)
	return googleIAPOrder
}

// HasGoogleIAPOrder checks if the googleIAPOrder exists in the store
func (k Keeper) HasGoogleIAPOrder(ctx sdk.Context, purchaseToken string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderKey))
	return store.Has(v1beta1.KeyPrefix(purchaseToken))
}

// GetGoogleIAPOrderOwner returns the creator of the
func (k Keeper) GetGoogleIAPOrderOwner(ctx sdk.Context, purchaseToken string) string {
	return k.GetGoogleIAPOrder(ctx, purchaseToken).Creator
}

// GetAllGoogleIAPOrder returns all googleIAPOrder
func (k Keeper) GetAllGoogleIAPOrder(ctx sdk.Context) (list []v1beta1.GoogleInAppPurchaseOrder) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.GoogleInAppPurchaseOrder
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetPaymentInfo set a specific paymentInfo in the store from its index
func (k Keeper) SetPaymentInfo(ctx sdk.Context, paymentInfo v1beta1.PaymentInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PaymentInfoKey))
	b := k.cdc.MustMarshal(&paymentInfo)
	store.Set(v1beta1.KeyPrefix(paymentInfo.PurchaseId), b)
}

// GetPaymentInfo returns a paymentInfo from its index
func (k Keeper) GetPaymentInfo(ctx sdk.Context, purchaseID string) (val v1beta1.PaymentInfo, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PaymentInfoKey))

	b := store.Get(v1beta1.KeyPrefix(purchaseID))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// HasPaymentInfo checks if the execution exists in the store
func (k Keeper) HasPaymentInfo(ctx sdk.Context, purchaseID string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PaymentInfoKey))
	return store.Has(v1beta1.KeyPrefix(purchaseID))
}

// GetAllPaymentInfo returns all paymentInfo
func (k Keeper) GetAllPaymentInfo(ctx sdk.Context) (list []v1beta1.PaymentInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.PaymentInfoKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.PaymentInfo
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

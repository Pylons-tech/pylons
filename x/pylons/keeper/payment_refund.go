package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetPaymentInfo set a specific paymentInfo in the store from its index
func (k Keeper) SetPaymentRefund(ctx sdk.Context, paymentInfo types.PaymentInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PaymentRefundKey))
	b := k.cdc.MustMarshal(&paymentInfo)
	store.Set(types.KeyPrefix(paymentInfo.PurchaseId), b)
}

// GetPaymentInfo returns a paymentInfo from its index
func (k Keeper) GetPaymentRefund(ctx sdk.Context, purchaseID string) (val types.PaymentInfo, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PaymentRefundKey))

	b := store.Get(types.KeyPrefix(purchaseID))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// HasPaymentInfo checks if the execution exists in the store
func (k Keeper) HasPaymentRefund(ctx sdk.Context, purchaseID string) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PaymentRefundKey))
	return store.Has(types.KeyPrefix(purchaseID))
}

// GetAllPaymentInfo returns all paymentInfo
func (k Keeper) GetAllPaymentRefund(ctx sdk.Context) (list []types.PaymentInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.PaymentRefundKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.PaymentInfo
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

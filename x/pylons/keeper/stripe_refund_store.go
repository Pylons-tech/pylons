package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetStripeRefund set the payment record when an nft purchase is failed in the store
func (k Keeper) SetStripeRefund(ctx sdk.Context, purchase *types.StripeRefund) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.StripeRefundKey))
	b := k.cdc.MustMarshal(purchase)
	store.Set(types.KeyPrefix(purchase.Payment.PurchaseId), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// GetAllStripeRefund returns all StripeRefund Record when requested for manual refund
func (k Keeper) GetAllStripeRefund(ctx sdk.Context) (list []*types.PaymentInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AppleInAppPurchaseOrderKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val *types.PaymentInfo
		k.cdc.MustUnmarshal(iterator.Value(), val)
		list = append(list, val)
	}

	return
}

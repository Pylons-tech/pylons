package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetStripeRefund set the payment record when an nft purchase is failed in the store
func (k Keeper) SetStripeRefund(ctx sdk.Context, purchase *v1beta1.StripeRefund) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.StripeRefundKey))
	b := k.cdc.MustMarshal(purchase)
	store.Set(v1beta1.KeyPrefix(purchase.Payment.PurchaseId), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// GetAllStripeRefund returns all StripeRefund Record when requested for manual refund
func (k Keeper) GetAllStripeRefund(ctx sdk.Context) (list []*v1beta1.StripeRefund) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.StripeRefundKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.StripeRefund
		b := iterator.Value()
		k.cdc.MustUnmarshal(b, &val)
		list = append(list, &val)
	}

	return
}

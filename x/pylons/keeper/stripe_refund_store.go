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
func (k Keeper) GetAllStripeRefund(ctx sdk.Context) (list []*types.StripeRefund) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.StripeRefundKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.StripeRefund
		b := iterator.Value()
		k.cdc.MustUnmarshal(b, &val)
		list = append(list, &val)
	}

	return
}

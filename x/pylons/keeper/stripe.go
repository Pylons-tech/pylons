package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HasStripeOrder checks if an stripe order exist
func (k Keeper) HasStripeOrder(ctx sdk.Context, token string) bool {
	store := ctx.KVStore(k.StripeOrderKey)
	return store.Has([]byte(token))
}

// RegisterStripeOrder is used to add an iap order
func (k Keeper) RegisterStripeOrder(ctx sdk.Context, iap types.StripeOrder) error {
	return k.SetObject(ctx, types.TypeStripeOrder, iap.PaymentId, k.StripeOrderKey, iap)
}

package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HasPaymentForStripe checks if an iap order exist
func (k Keeper) HasPaymentForStripe(ctx sdk.Context, paymentId string) bool {
	store := ctx.KVStore(k.PaymentForStripeKey)
	return store.Has([]byte(paymentId))
}

// RegisterPaymentForStripe is used to add an iap order
func (k Keeper) RegisterPaymentForStripe(ctx sdk.Context, paymentId string) error {
	return k.SetObject(ctx, "payment_id_for_stripe", paymentId, k.PaymentForStripeKey, paymentId)
}

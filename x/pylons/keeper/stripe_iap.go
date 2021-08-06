package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HasPaymentForStripe checks if an iap order exist
func (k Keeper) HasPaymentForStripe(ctx sdk.Context, paymentID string) bool {
	store := ctx.KVStore(k.PaymentForStripeKey)
	return store.Has([]byte(paymentID))
}

// RegisterPaymentForStripe is used to add an iap order
func (k Keeper) RegisterPaymentForStripe(ctx sdk.Context, paymentID string) error {
	return k.SetObject(ctx, "payment_id_for_stripe", paymentID, k.PaymentForStripeKey, paymentID)
}

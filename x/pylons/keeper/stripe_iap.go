package keeper

import (
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
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

func (keeper Keeper) SetPaymentID(ctx sdk.Context, stripe types.MsgExecuteRecipe) error {
	if stripe.PaymentId == "" {
		return errors.New("SetPaymentID: the PaymentID cannot be empty")
	}
	return keeper.SetObject(ctx, types.TypePaymentID, stripe.PaymentId, keeper.PaymentIDKey, stripe)
}

func (keeper Keeper) HasPaymentID(ctx sdk.Context, paymentID string) bool {
	store := ctx.KVStore(keeper.PaymentIDKey)
	return store.Has([]byte(paymentID))
}

package handlers

import (
	"context"
	"encoding/base64"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/checkout/session"
)

// StripeCheckout is used to execute a recipe
func (k msgServer) StripeCheckout(ctx context.Context, msg *types.MsgStripeCheckout) (*types.MsgStripeCheckoutResponse, error) {
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	//sdkCtx := sdk.UnwrapSDKContext(ctx)
	//sender, _ := sdk.AccAddressFromBech32(msg.Sender)
	stripeSecKeyBytes, err := base64.StdEncoding.DecodeString(msg.StripeKey)
	if err != nil {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error stripe key store base64 public key decoding failure: %s", err.Error())
	}
	stripe.Key = string(stripeSecKeyBytes)
	lineItemParams := stripe.CheckoutSessionLineItemParams{
		Amount:      stripe.Int64(msg.Price.Amount),
		Currency:    stripe.String(msg.Price.Currency),
		Description: stripe.String(msg.Price.Description),
		Images:      stripe.StringSlice(msg.Price.Images),
		Name:        stripe.String(msg.Price.Name),
		Quantity:    stripe.Int64(msg.Price.Quantity),
	}
	params := &stripe.CheckoutSessionParams{
		PaymentMethodTypes: stripe.StringSlice([]string{msg.PaymentMethod}),
		LineItems: []*stripe.CheckoutSessionLineItemParams{
			&lineItemParams,
		},
		Mode: stripe.String(string(stripe.CheckoutSessionModePayment)),
	}

	sessionId, err := session.New(params)
	if err != nil {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error checkout session: %s", err.Error())
	}
	return &types.MsgStripeCheckoutResponse{
		SessionID: sessionId.ID,
		Message:   "successfully checkout session",
		Status:    "Success",
	}, nil
}

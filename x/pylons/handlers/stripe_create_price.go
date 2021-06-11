package handlers

import (
	"context"
	"encoding/base64"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stripe/stripe-go"
)

// StripeCreatePrice is used to execute a recipe
func (k msgServer) StripeCreatePrice(ctx context.Context, msg *types.MsgStripeCreatePrice) (*types.MsgStripeCreatePriceResponse, error) {
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
	// params := &stripe.PriceParams{
	// 	Product:     stripe.String(msg.Product),
	// 	UnitAmount:  stripe.String(msg.Amount),
	// 	Currency:    stripe.String(msg.Currency),
	// 	Description: stripe.String(msg.Description),
	// }

	// priceId, err := price.New(params)
	if err != nil {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error create price: %s", err.Error())
	}
	return &types.MsgStripeCreatePriceResponse{
		PriceID: "priceId.ID",
		Message: "successfully create price",
		Status:  "Success",
	}, nil
}

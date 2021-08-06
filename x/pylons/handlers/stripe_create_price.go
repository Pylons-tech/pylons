package handlers

import (
	"context"
	"encoding/base64"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stripe/stripe-go"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// StripeCreatePrice is used to execute a recipe
func (k msgServer) StripeCreatePrice(ctx context.Context, msg *types.MsgStripeCreatePrice) (*types.MsgStripeCreatePriceResponse, error) {
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	stripeSecKeyBytes, err := base64.StdEncoding.DecodeString(msg.StripeKey)
	if err != nil {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error stripe key store base64 public key decoding failure: %s", err.Error())
	}
	stripe.Key = string(stripeSecKeyBytes)

	if err != nil {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error create price: %s", err.Error())
	}
	return &types.MsgStripeCreatePriceResponse{
		PriceID: "priceId.ID",
		Message: "successfully create price",
		Status:  "Success",
	}, nil
}

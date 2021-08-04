package handlers

import (
	"context"
	"fmt"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/product"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// StripeCreateProduct is used to execute a recipe
func (k msgServer) StripeCreateProduct(ctx context.Context, msg *types.MsgStripeCreateProduct) (*types.MsgStripeCreateProductResponse, error) {
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	stripe.Key = msg.StripeKey

	params := &stripe.ProductParams{
		Name:        stripe.String(msg.Name),
		Description: stripe.String(msg.Description),
		// Images:              stripe.StringSlice(msg.Images),
		StatementDescriptor: stripe.String(msg.StatementDescriptor),
		UnitLabel:           stripe.String(msg.UnitLabel),
	}
	productId, err := product.New(params)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("error create product: %s", err.Error()))
	}
	return &types.MsgStripeCreateProductResponse{
		ProductID: productId.ID,
		Message:   "successfully create product",
		Status:    "Success",
	}, nil
}

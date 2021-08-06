package handlers

import (
	"context"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/sku"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// StripeCreateSku is used to execute a recipe
func (k msgServer) StripeCreateSku(ctx context.Context, msg *types.MsgStripeCreateSku) (*types.MsgStripeCreateSkuResponse, error) {
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	stripe.Key = msg.StripeKey
	inventoryParams := stripe.InventoryParams{
		Quantity: &msg.Inventory.Quantity,
		Type:     &msg.Inventory.Type,
	}
	mapAttribute := make(map[string]string)
	for _, attr := range msg.Attributes {
		mapAttribute[attr.Key] = attr.Value
	}

	params := &stripe.SKUParams{
		Product:    stripe.String(msg.Product),
		Attributes: mapAttribute,
		Price:      stripe.Int64(msg.Price),
		Currency:   stripe.String(msg.Currency),
		Inventory:  &inventoryParams,
	}
	skuID, err := sku.New(params)

	if err != nil {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error create sku: %s", err.Error())
	}
	return &types.MsgStripeCreateSkuResponse{
		SKUID:   skuID.ID,
		Message: "successfully create sku",
		Status:  "Success",
	}, nil

}

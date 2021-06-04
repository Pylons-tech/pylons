package handlers

import (
	"context"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/sku"
)

// StripeCreateSku is used to execute a recipe
func (k msgServer) StripeCreateSku(ctx context.Context, msg *types.MsgStripeCreateSku) (*types.MsgStripeCreateSkuResponse, error) {
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	//sdkCtx := sdk.UnwrapSDKContext(ctx)
	//sender, _ := sdk.AccAddressFromBech32(msg.Sender)
	/*stripeSecKeyBytes, err := base64.StdEncoding.DecodeString(msg.StripeKey)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("error stripe key store base64 public key decoding failure: %s", err.Error()))
	}
	stripe.Key = string(stripeSecKeyBytes)*/
	stripe.Key = string(msg.StripeKey)
	inventoryParams := stripe.InventoryParams{
		Quantity: &msg.Inventory.Quantity,
		Type:     &msg.Inventory.Type, //stripe.SKUInventoryTypeFinite
		// Value:    &msg.Inventory.Value,
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
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("error create sku: %s", err.Error()))
	}
	return &types.MsgStripeCreateSkuResponse{
		SKUID:   skuID.ID,
		Message: "successfully create sku",
		Status:  "Success",
	}, nil
}

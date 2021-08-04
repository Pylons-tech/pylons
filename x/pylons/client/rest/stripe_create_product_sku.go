package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/product"
	"github.com/stripe/stripe-go/sku"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

type stripeCreateSkuReq struct {
	BaseReq     rest.BaseReq `json:"base_req"`
	StripeKey   string
	Name        string
	Description string
	Images      []string
	Attributes  types.StringKeyValueList
	Price       int64
	Currency    string
	Inventory   *types.StripeInventory
	ClientId    string
	Sender      string
}

type stripeSkuRes struct {
	SKU_ID string `json:"stripe_sku_id"`
}

func stripeCreateProductSkuHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripeCreateSkuReq
		if !rest.ReadRESTReq(w, r, cliCtx.LegacyAmino, &req) {
			rest.WriteErrorResponse(w, http.StatusBadRequest, "failed to parse request")
			return
		}

		addr, err := sdk.AccAddressFromBech32(req.Sender)
		if err != nil {
			//rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			rest.PostProcessResponse(w, cliCtx, err.Error())
			return
		}

		baseReq := req.BaseReq.Sanitize()
		baseReq.ChainID = string(config.Config.ChainID)
		baseReq.From = addr.String()

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		// create the message
		msg := types.NewMsgStripeCreateProductSku(config.Config.StripeConfig.StripeSecretKey,
			req.Name,
			req.Description,
			req.Images,
			req.Attributes,
			req.Price,
			req.Currency,
			req.Inventory,
			req.ClientId,
			addr.String())
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		stripe.Key = string(msg.StripeKey)
		params := &stripe.ProductParams{
			Name:        stripe.String(msg.Name),
			Description: stripe.String(msg.Description),
			// Images:              stripe.StringSlice(msg.Images),
			Type: stripe.String("good"),
		}
		params.AddMetadata("ClientId", msg.ClientId)
		productId, err := product.New(params)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create product: %s", err.Error()))
			return
		}

		inventoryParams := stripe.InventoryParams{
			Quantity: &msg.Inventory.Quantity,
			Type:     &msg.Inventory.Type, //stripe.SKUInventoryTypeFinite
			// Value:    &msg.Inventory.Value,
		}
		mapAttribute := make(map[string]string)
		for _, attr := range msg.Attributes {
			mapAttribute[attr.Key] = attr.Value
		}
		skuParams := &stripe.SKUParams{
			Product:    stripe.String(productId.ID),
			Attributes: mapAttribute,
			Price:      stripe.Int64(msg.Price),
			Currency:   stripe.String(msg.Currency),
			Inventory:  &inventoryParams,
		}
		skuParams.AddMetadata("ClientId", msg.ClientId)
		skuID, err := sku.New(skuParams)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create sku: %s", err.Error()))
		}

		var result stripeSkuRes
		result.SKU_ID = skuID.ID
		rest.PostProcessResponse(w, cliCtx, result)
	}
}

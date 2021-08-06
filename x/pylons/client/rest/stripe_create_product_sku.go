package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/product"
	"github.com/stripe/stripe-go/sku"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
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
	ClientID    string
	Sender      string
}

type stripeSkuRes struct {
	SkuID string `json:"stripe_sku_id"`
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
			rest.PostProcessResponse(w, cliCtx, err.Error())
			return
		}

		baseReq := req.BaseReq.Sanitize()
		baseReq.ChainID = config.Config.ChainID
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
			req.ClientID,
			addr.String())
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		stripe.Key = msg.StripeKey
		params := &stripe.ProductParams{
			Name:        stripe.String(msg.Name),
			Description: stripe.String(msg.Description),
			// Images:              stripe.StringSlice(msg.Images),
			Type: stripe.String("good"),
		}
		params.AddMetadata("ClientID", msg.ClientID)
		productId, err := product.New(params)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create product: %s", err.Error()))
			return
		}

		inventoryParams := stripe.InventoryParams{
			Quantity: &msg.Inventory.Quantity,
			Type:     &msg.Inventory.Type,
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
		skuParams.AddMetadata("ClientID", msg.ClientID)
		skuID, err := sku.New(skuParams)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create sku: %s", err.Error()))
		}

		var result stripeSkuRes
		result.SkuID = skuID.ID
		rest.PostProcessResponse(w, cliCtx, result)
	}
}

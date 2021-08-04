package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/product"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

type stripeCreateProductReq struct {
	BaseReq             rest.BaseReq `json:"base_req"`
	StripeKey           string
	Name                string
	Description         string
	Images              []string
	StatementDescriptor string
	UnitLabel           string
	Sender              string
}

func stripeCreateProductHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripeCreateProductReq
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

		msg := types.NewMsgStripeCreateProduct(req.StripeKey, req.Name, req.Description, req.Images, req.StatementDescriptor, req.UnitLabel, addr.String())
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
			StatementDescriptor: stripe.String(msg.StatementDescriptor),
			UnitLabel:           stripe.String(msg.UnitLabel),
		}
		productId, err := product.New(params)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create product: %s", err.Error()))
		}

		rest.PostProcessResponse(w, cliCtx, productId.ID)
	}
}

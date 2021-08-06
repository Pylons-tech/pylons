package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/product"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"

	"github.com/Pylons-tech/pylons/x/pylons/types"
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
			rest.PostProcessResponse(w, cliCtx, fmt.Sprintf("error valid address: %s", err.Error()))
			return
		}

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
		stripe.Key = msg.StripeKey

		params := &stripe.ProductParams{
			Name:        stripe.String(msg.Name),
			Description: stripe.String(msg.Description),
			// Images:              stripe.StringSlice(msg.Images),
			StatementDescriptor: stripe.String(msg.StatementDescriptor),
			UnitLabel:           stripe.String(msg.UnitLabel),
		}
		productID, err := product.New(params)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create product: %s", err.Error()))
		}

		rest.PostProcessResponse(w, cliCtx, productID.ID)
	}
}

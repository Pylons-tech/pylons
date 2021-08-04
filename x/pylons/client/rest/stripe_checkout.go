package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/checkout/session"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

type stripeCreateCheckoutReq struct {
	BaseReq       rest.BaseReq `json:"base_req"`
	StripeKey     string
	PaymentMethod string
	Amount        int64
	Currency      string
	Images        []string
	Description   string
	Name          string
	Quantity      int64
	Sender        string
}

func stripeCheckoutHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripeCreateCheckoutReq

		if !rest.ReadRESTReq(w, r, cliCtx.LegacyAmino, &req) {
			rest.PostProcessResponse(w, cliCtx, "failed to parse request")
			return
		}

		addr, err := sdk.AccAddressFromBech32(req.Sender)
		if err != nil {
			rest.PostProcessResponse(w, cliCtx, err.Error())
			return
		}

		baseReq := req.BaseReq.Sanitize()
		baseReq.ChainID = string(config.Config.ChainID)
		baseReq.From = addr.String()

		if !baseReq.ValidateBasic(w) {
			rest.PostProcessResponse(w, cliCtx, "ValidateBasic error")
			return
		}

		price := types.StripePrice{
			Amount:      req.Amount,
			Currency:    req.Currency,
			Description: req.Description,
			Images:      req.Images,
			Name:        req.Name,
			Quantity:    req.Quantity,
		}

		req.StripeKey = string(config.Config.StripeConfig.StripeSecretKey)
		msg := types.NewMsgStripeCheckout(req.StripeKey, req.PaymentMethod, &price, addr.String())
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, "ValidateBasic error")
			return
		}

		stripe.Key = req.StripeKey
		lineItemParams := stripe.CheckoutSessionLineItemParams{
			Amount:      stripe.Int64(msg.Price.Amount),
			Currency:    stripe.String(msg.Price.Currency),
			Description: stripe.String(msg.Price.Description),
			// Images:      stripe.StringSlice(msg.Price.Images),
			Name:     stripe.String(msg.Price.Name),
			Quantity: stripe.Int64(msg.Price.Quantity),
		}

		params := &stripe.CheckoutSessionParams{
			SuccessURL:         stripe.String(config.Config.StripeConfig.StripeRedirectURI),
			CancelURL:          stripe.String(config.Config.StripeConfig.StripeCancelURI),
			PaymentMethodTypes: stripe.StringSlice([]string{msg.PaymentMethod}),
			LineItems: []*stripe.CheckoutSessionLineItemParams{
				&lineItemParams,
			},
			SubscriptionData: &stripe.CheckoutSessionSubscriptionDataParams{
				Items: []*stripe.CheckoutSessionSubscriptionDataItemsParams{
					{
						Plan:     stripe.String("plan"),
						Quantity: stripe.Int64(2),
					},
				},
			},
			Mode: stripe.String(string(stripe.CheckoutSessionModePayment)),
		}

		sessionId, err := session.New(params)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error checkout session: %s", err.Error()))
		}
		rest.PostProcessResponse(w, cliCtx, sessionId)
	}
}

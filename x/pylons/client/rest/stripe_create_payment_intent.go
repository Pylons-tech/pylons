package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/ephemeralkey"
	"github.com/stripe/stripe-go/paymentintent"
	"github.com/stripe/stripe-go/sku"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

type stripeCreatePaymentIntentReq struct {
	BaseReq    rest.BaseReq `json:"base_req"`
	StripeKey  string
	Amount     int64
	Currency   string
	SKUID      string
	Sender     string
	CustomerId string
}

type stripePaymentRes struct {
	PAYMENT_ID    string `json:"stripe_payment_intent_id"`
	CLIENT_SECRET string `json:"client_secret"`
	EPHEMERAL_KEY string `json:"stripe_ephemeralKey"`
	CURSTOMER_ID  string `json:"stripe_customer_id"`
}

func stripeCreatePaymentIntentHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripeCreatePaymentIntentReq

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
		baseReq.ChainID = "test"
		baseReq.From = addr.String()

		if !baseReq.ValidateBasic(w) {
			rest.PostProcessResponse(w, cliCtx, "ValidateBasic error")
			return
		}

		// stripeSecKeyBytes, err := base64.StdEncoding.DecodeString(config.Config.StripeConfig.StripeSecretKey)
		// if err != nil {
		// 	rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		// }
		req.StripeKey = string(config.Config.StripeConfig.StripeSecretKey) //stripeSecKeyBytes

		stripe.Key = req.StripeKey
		skuResult, err := sku.Get(req.SKUID, nil)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error retrieve sku: %s", err.Error()))
			return
		}

		// create the message
		msg := types.NewMsgStripeCreatePaymentIntent(req.StripeKey, req.Amount, req.Currency, req.SKUID, addr.String(), req.CustomerId)
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		// customerParams := &stripe.CustomerParams{
		// 	Description: stripe.String(addr.String()),
		// }
		// customer, err := customer.New(customerParams)
		// if err != nil {
		// 	rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create customer: %s", err.Error()))
		// 	return
		// }

		ephEmeralKeyParams := &stripe.EphemeralKeyParams{
			Customer:      &req.CustomerId,
			StripeVersion: stripe.String("2020-08-27"),
		}

		ephEmeralKey, err := ephemeralkey.New(ephEmeralKeyParams)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create ephemeralKey: %s", err.Error()))
			return
		}

		params := &stripe.PaymentIntentParams{
			Amount:     stripe.Int64(skuResult.Price),
			Currency:   stripe.String(string(skuResult.Currency)),
			Customer:   stripe.String(req.CustomerId),
			OnBehalfOf: stripe.String(skuResult.Metadata["ClientId"]),
		}

		paymentIntent, err := paymentintent.New(params)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error create paymentintent: %s", err.Error()))
			return
		}

		var result stripePaymentRes
		result.PAYMENT_ID = paymentIntent.ID
		result.CLIENT_SECRET = paymentIntent.ClientSecret
		result.CURSTOMER_ID = req.CustomerId
		result.EPHEMERAL_KEY = ephEmeralKey.ID
		rest.PostProcessResponse(w, cliCtx, result)
		//tx.WriteGeneratedTxResponse(cliCtx, w, baseReq, []sdk.Msg{&msg}...)
	}
}

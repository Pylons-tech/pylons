package rest

import (
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/paymentintent"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

type stripeCreatePaymentIntentReq struct {
	BaseReq   rest.BaseReq `json:"base_req"`
	StripeKey string
	Amount    int64
	Currency  string
	Paymethod string
	Sender    string
}

func stripeCratePaymentIntentHandler(cliCtx client.Context) http.HandlerFunc {
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
		// create the message
		msg := types.NewMsgStripeCreatePaymentIntent(req.StripeKey, req.Amount, req.Currency, req.Paymethod, addr.String())
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		stripe.Key = req.StripeKey

		params := &stripe.PaymentIntentParams{
			Amount:   stripe.Int64(req.Amount),
			Currency: stripe.String(req.Currency),
			// OnBehalfOf: ,
			// Application
			PaymentMethodTypes: []*string{
				stripe.String(req.Paymethod),
			},
		}

		paymentId, err := paymentintent.New(params)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}
		rest.PostProcessResponse(w, cliCtx, paymentId.ClientSecret)
		//tx.WriteGeneratedTxResponse(cliCtx, w, baseReq, []sdk.Msg{&msg}...)
	}
}

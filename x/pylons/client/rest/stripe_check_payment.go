package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/stripe/stripe-go/paymentintent"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

type stripeCheckPaymentReq struct {
	BaseReq   rest.BaseReq `json:"base_req"`
	StripeKey string
	PaymentID string
	Sender    string
}

type stripeCheckPaymentRes struct {
	PaymentStatus int `json:"payment_status"`
}

const (
	PaymentSuccess = iota
	PaymentFailed
)

func stripeCheckPaymentHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripeCheckPaymentReq
		if !rest.ReadRESTReq(w, r, cliCtx.LegacyAmino, &req) {
			rest.WriteErrorResponse(w, http.StatusBadRequest, "failed to parse request")
			return
		}
		addr, err := sdk.AccAddressFromBech32(req.Sender)
		if err != nil {
			rest.PostProcessResponse(w, cliCtx, fmt.Sprintf("error valid address: %s", err.Error()))
			return
		}
		baseReq := req.BaseReq.Sanitize()
		baseReq.ChainID = config.Config.ChainID
		baseReq.From = addr.String()

		if !baseReq.ValidateBasic(w) {
			rest.PostProcessResponse(w, cliCtx, "ValidateBasic error")
			return
		}

		req.StripeKey = config.Config.StripeConfig.StripeSecretKey

		// create the message
		msg := types.NewMsgStripeCheckPayment(req.StripeKey, req.PaymentID, addr.String())

		err = msg.ValidateBasic()
		if err != nil {
			rest.PostProcessResponse(w, cliCtx, fmt.Sprintf("error validate msg: %s", err.Error()))
			return
		}

		stripe.Key = req.StripeKey
		pi, _ := paymentintent.Get(
			msg.PaymentID,
			nil,
		)

		var result stripeCheckPaymentRes
		result.PaymentStatus = PaymentSuccess
		if pi.Status != "succeeded" {
			result.PaymentStatus = PaymentFailed
		}

		rest.PostProcessResponse(w, cliCtx, result)
	}
}

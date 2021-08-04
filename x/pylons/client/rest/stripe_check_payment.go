package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/stripe/stripe-go/paymentintent"
)

type stripeCheckPaymentReq struct {
	BaseReq   rest.BaseReq `json:"base_req"`
	StripeKey string
	PaymentID string
	Sender    string
}

type stripeCheckPaymentRes struct {
	Payment_status int `json:"payment_status"`
}

const PAYMENT_SUCCESS = 1
const PAYMENT_FAILED = -1

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
		baseReq.ChainID = "test"
		baseReq.From = addr.String()

		if !baseReq.ValidateBasic(w) {
			rest.PostProcessResponse(w, cliCtx, "ValidateBasic error")
			return
		}

		req.StripeKey = string(config.Config.StripeConfig.StripeSecretKey) //stripeSecKeyBytes

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
		result.Payment_status = PAYMENT_SUCCESS
		if pi.Status != "succeeded" {
			result.Payment_status = PAYMENT_FAILED
		}

		// err = k.RegisterPaymentForStripe(sdkCtx, msg.PaymentID)

		// if err != nil {
		// 	return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error registering payment id for Stripe")
		// } //to do  RegisterPaymentForStripe RegisterPaymentForStripe

		rest.PostProcessResponse(w, cliCtx, result)
	}
}

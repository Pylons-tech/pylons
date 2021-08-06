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

type PaymentHistoryStu struct {
	ID           string
	Amount       int64
	Currency     string
	CustomerID   string
	ClientSecret string
	Status       string
	Created      int64
}

type stripePaymentHistoryListReq struct {
	BaseReq    rest.BaseReq `json:"base_req"`
	StripeKey  string
	CustomerID string
	Sender     string
}

type stripePaymentHistoryListRes struct {
	PaymentList []PaymentHistoryStu `json:"stripe_payment_history"`
	Length      int                 `json:"length"`
}

func stripePaymentHistoryListHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripePaymentHistoryListReq
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
		msg := types.NewMsgStripePaymentHistoryList(req.StripeKey, req.CustomerID, addr.String())

		err = msg.ValidateBasic()
		if err != nil {
			rest.PostProcessResponse(w, cliCtx, fmt.Sprintf("error validate msg: %s", err.Error()))
			return
		}

		stripe.Key = req.StripeKey

		params := &stripe.PaymentIntentListParams{
			Customer: stripe.String(req.CustomerID),
		}

		var paymentHistory stripePaymentHistoryListRes
		paymentHistory.Length = 0
		paymentHistory.PaymentList = nil

		var length = 0
		params.Filters.AddFilter("limit", "", "100")
		i := paymentintent.List(params)

		for i.Next() {
			pi := i.PaymentIntent()
			var payment PaymentHistoryStu
			payment.Amount = pi.Amount
			payment.ClientSecret = pi.ClientSecret
			payment.Currency = pi.Currency
			payment.CustomerID = pi.Customer.ID
			payment.ID = pi.ID
			payment.Status = string(pi.Status)
			payment.Created = pi.Created
			paymentHistory.PaymentList = append(paymentHistory.PaymentList, payment)
			length++
		}
		paymentHistory.Length = length
		rest.PostProcessResponse(w, cliCtx, paymentHistory.PaymentList)
	}
}

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

type PaymentHistoryStu struct {
	ID            string
	PaymentMethod string
	Amount        int64
	Currency      string
	CustomerId    string
	ClientSecret  string
	Description   string
	Status        string
}

type stripePaymentHistoryListReq struct {
	BaseReq    rest.BaseReq `json:"base_req"`
	StripeKey  string
	CustomerId string
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
		baseReq.ChainID = "test"
		baseReq.From = addr.String()

		if !baseReq.ValidateBasic(w) {
			rest.PostProcessResponse(w, cliCtx, "ValidateBasic error")
			return
		}

		req.StripeKey = string(config.Config.StripeConfig.StripeSecretKey) //stripeSecKeyBytes

		// create the message
		msg := types.NewMsgStripePaymentHistoryLIst(req.StripeKey, req.CustomerId, addr.String())

		err = msg.ValidateBasic()
		if err != nil {
			rest.PostProcessResponse(w, cliCtx, fmt.Sprintf("error validate msg: %s", err.Error()))
			return
		}

		stripe.Key = req.StripeKey

		params := &stripe.PaymentIntentListParams{}

		var paymentHistory stripePaymentHistoryListRes
		paymentHistory.Length = 0
		paymentHistory.PaymentList = nil
		if params.Context == nil {
			rest.PostProcessResponse(w, cliCtx, paymentHistory)
			return
		}
		var length = 0
		params.Filters.AddFilter("limit", "", "100")
		i := paymentintent.List(params)

		for i.Next() {
			pi := i.PaymentIntent()
			var payment PaymentHistoryStu
			payment.Amount = pi.Amount
			payment.ClientSecret = pi.ClientSecret
			payment.Currency = pi.Currency
			payment.CustomerId = pi.Customer.ID
			payment.Description = pi.Description
			payment.ID = pi.ID
			payment.PaymentMethod = string(pi.PaymentMethod.ID)
			payment.Status = string(pi.Status)
			if pi.Customer.ID == msg.CustomerId {
				paymentHistory.PaymentList = append(paymentHistory.PaymentList, payment)
				length = length + 1
			}
		}
		paymentHistory.Length = length
		rest.PostProcessResponse(w, cliCtx, paymentHistory.PaymentList)
	}
}

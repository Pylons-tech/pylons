package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/customer"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

type stripeCreateCustomerIDReq struct {
	BaseReq   rest.BaseReq `json:"base_req"`
	StripeKey string
	Sender    string
}

type stripeCreateCustomerIDRes struct {
	CURSTOMER_ID string `json:"stripe_customer_id"`
}

func stripeCreateCustomerIDHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripeCreateCustomerIDReq
		if !rest.ReadRESTReq(w, r, cliCtx.LegacyAmino, &req) {
			rest.WriteErrorResponse(w, http.StatusBadRequest, "failed to parse request")
			return
		}
		addr, err := sdk.AccAddressFromBech32(req.Sender)
		if err != nil {
			//rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			rest.PostProcessResponse(w, cliCtx, fmt.Sprintf("error create address: %s", err.Error()))
			return
		}
		baseReq := req.BaseReq.Sanitize()
		baseReq.ChainID = string(config.Config.ChainID)
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

		// create the message
		msg := types.NewMsgStripeCreateCustomerID(req.StripeKey, addr.String())

		err = msg.ValidateBasic()
		if err != nil {
			rest.PostProcessResponse(w, cliCtx, fmt.Sprintf("error validate msg: %s", err.Error()))
			return
		}
		customerParams := &stripe.CustomerParams{
			Name: stripe.String(addr.String()),
		}
		customer, err := customer.New(customerParams)
		if err != nil {
			rest.PostProcessResponse(w, cliCtx, fmt.Sprintf("error create customer: %s", err.Error()))
			return
		}
		var result stripeCreateCustomerIDRes
		result.CURSTOMER_ID = customer.ID
		//rest.PostProcessResponse(w, cliCtx, result)
		rest.PostProcessResponse(w, cliCtx, result)
	}
}

package rest

import (
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/account"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

type stripeCreateAccountReq struct {
	BaseReq   rest.BaseReq `json:"base_req"`
	StripeKey string
	Country   string
	Email     string
	Type      string
	Sender    string
}

func stripeCrateAccountHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripeCreateAccountReq

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
		msg := types.NewMsgStripeCreateAccount(req.StripeKey, req.Country, req.Email, req.Type, addr.String())
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		stripe.Key = req.StripeKey

		params := &stripe.AccountParams{
			Country: stripe.String(msg.Country),
			Email:   stripe.String(msg.Email),
			Type:    stripe.String(msg.Types),
		}

		account, err := account.New(params)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}
		rest.PostProcessResponse(w, cliCtx, account.ID)
		//tx.WriteGeneratedTxResponse(cliCtx, w, baseReq, []sdk.Msg{&msg}...)
	}
}

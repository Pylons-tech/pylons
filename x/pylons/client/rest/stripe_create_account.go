package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/account"
	"github.com/stripe/stripe-go/accountlink"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
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
			rest.PostProcessResponse(w, cliCtx, err.Error())
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

		linkParams := &stripe.AccountLinkParams{
			Account:    stripe.String(account.ID),
			Type:       stripe.String("account_onboarding"),
			SuccessURL: stripe.String("https://pylons/return"),
			FailureURL: stripe.String("https://pylons/fail"),
		}

		aLink, err := accountlink.New(linkParams)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error account link: %s", err.Error()))
			return
		}
		rest.PostProcessResponse(w, cliCtx, aLink)
	}
}

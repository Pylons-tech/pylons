package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/oauth"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

type stripeOauthTokenReq struct {
	BaseReq        rest.BaseReq `json:"base_req"`
	StripeKey      string
	StripeClientID string
	GrantType      string
	Code           string
	Sender         string
}

func stripeOAuthTokenHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req stripeOauthTokenReq

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
		req.StripeClientID = config.Config.StripeConfig.StripeClientID
		msg := types.NewMsgStripeOauthToken(req.GrantType, req.Code, addr.String())
		err = msg.ValidateBasic()
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}
		stripe.Key = req.StripeKey
		params := &stripe.OAuthTokenParams{
			GrantType: stripe.String(msg.GrantType),
			Code:      stripe.String(msg.Code),
		}

		oauthToken, err := oauth.New(params)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error oauthToken: %s - stripe.StripeClientID %s", err.Error(), req.StripeClientID))
			return
		}
		rest.PostProcessResponse(w, cliCtx, oauthToken)
	}
}

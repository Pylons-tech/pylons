package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/stripe/stripe-go"
	"github.com/stripe/stripe-go/oauth"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
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

		req.StripeKey = string(config.Config.StripeConfig.StripeSecretKey) //stripeSecKeyBytes
		req.StripeClientID = string(config.Config.StripeConfig.StripeClientID)
		// create the message
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

		oauth_token, err := oauth.New(params)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, fmt.Sprintf("error oauth_token: %s - stripe.StripeClientID %s", err.Error(), req.StripeClientID))
			return
		}
		rest.PostProcessResponse(w, cliCtx, oauth_token)
		//tx.WriteGeneratedTxResponse(cliCtx, w, baseReq, []sdk.Msg{&msg}...)
	}
}

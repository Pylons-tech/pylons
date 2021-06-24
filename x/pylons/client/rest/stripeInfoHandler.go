package rest

import (
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

type stripeInfoReq struct {
	BaseReq   rest.BaseReq `json:"base_req"`
	StripeKey string
	Sender    string
}

type stripeInfoRes struct {
	Pub_Key      string `json:"Public_Key"`
	ClientID     string `json:"ClientID"`
	Redirect_Uri string `json:"Redirect_Uri"`
}

func stripeInfoHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var res stripeInfoRes
		res.Pub_Key = string(config.Config.StripeConfig.StripePubKey)
		res.ClientID = string(config.Config.StripeConfig.StripeClientID)
		res.Redirect_Uri = string(config.Config.StripeConfig.StripeRedirectURI)
		rest.PostProcessResponse(w, cliCtx, res)
	}
}

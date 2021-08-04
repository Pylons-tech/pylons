package rest

import (
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/cosmos/cosmos-sdk/types/rest"

	"github.com/Pylons-tech/pylons/x/pylons/config"
)

type stripeInfoRes struct {
	PubKey      string `json:"Public_Key"`
	ClientID    string `json:"ClientID"`
	RedirectURI string `json:"RedirectURI"`
}

func stripeInfoHandler(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var res stripeInfoRes
		res.PubKey = config.Config.StripeConfig.StripePubKey
		res.ClientID = config.Config.StripeConfig.StripeClientID
		res.RedirectURI = config.Config.StripeConfig.StripeRedirectURI
		rest.PostProcessResponse(w, cliCtx, res)
	}
}

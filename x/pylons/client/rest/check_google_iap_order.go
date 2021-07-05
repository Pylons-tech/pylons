package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/gorilla/mux"

	"github.com/cosmos/cosmos-sdk/types/rest"
)

func checkGoogleIAPOrderHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		purchaseToken := vars[purchaseTokenKey]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/check_google_iap_order/%s", storeName, purchaseToken), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

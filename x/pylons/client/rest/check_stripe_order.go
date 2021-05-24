package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/gorilla/mux"
)

func checkStripeOrderHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		paymentId := vars[paymentId]
		//paymentMethod := vars[paymentMethod]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/check_stripe_order/%s", storeName, paymentId), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

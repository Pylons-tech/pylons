package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/gorilla/mux"

	"github.com/cosmos/cosmos-sdk/types/rest"
)

func getTradeHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		tradeKey := vars[tradeKeyName]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/get_trade/%s", storeName, tradeKey), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

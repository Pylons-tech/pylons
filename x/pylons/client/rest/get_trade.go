package rest

import (
	"fmt"
	"github.com/cosmos/cosmos-sdk/client"
	"net/http"

	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/gorilla/mux"
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

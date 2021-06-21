package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/gorilla/mux"

	"github.com/cosmos/cosmos-sdk/types/rest"
)

func getLockedCoinsHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		sender := vars[senderKey]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/get_locked_coins/%s", storeName, sender), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

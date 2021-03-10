package rest

import (
	"fmt"
	"github.com/cosmos/cosmos-sdk/client"
	"net/http"

	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/gorilla/mux"
)

func addrFromPubkeyHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		hexPubKey := vars[pubKeyName]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/addr_from_pub_key/%s", storeName, hexPubKey), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

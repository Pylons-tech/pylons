package rest

import (
	"fmt"
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/gorilla/mux"

	"github.com/cosmos/cosmos-sdk/types/rest"
)

func listRecipesHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		ownerKey := vars[ownerKeyName]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_recipe/%s", storeName, ownerKey), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

func listShortenRecipesHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		ownerKey := vars[ownerKeyName]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_shorten_recipe/%s", storeName, ownerKey), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

func listRecipesByCookbookHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		cookbookKey := vars[cookbookKeyName]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_recipe_by_cookbook/%s", storeName, cookbookKey), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

func listShortenRecipesByCookbookHandler(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		cookbookKey := vars[cookbookKeyName]

		res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_shorten_recipe_by_cookbook/%s", storeName, cookbookKey), nil)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusNotFound, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, res)
	}
}

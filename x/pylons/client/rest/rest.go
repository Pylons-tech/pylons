package rest

import (
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/client/rest/txbuilder"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"

	"github.com/gorilla/mux"
)

const (
	restName = "pylons"

	// DefaultCoinPerRequest is the number of coins the faucet sends per req
	DefaultCoinPerRequest = 500
	pubKeyName            = "pubkey"
	ownerKeyName          = "ownerKey"
)

// RegisterRoutes adds routes
func RegisterRoutes(cliCtx context.CLIContext, r *mux.Router, cdc *codec.Codec, storeName string) {
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons/tx_build/{%s}", storeName, txbuilder.TxGPRequesterKey),
		txbuilder.GetPylonsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons/tx_build/", storeName),
		txbuilder.SendPylonsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/create_cookbook/tx_build/", storeName),
		txbuilder.CreateCookbookTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/update_cookbook/tx_build/", storeName),
		txbuilder.UpdateCookbookTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/create_recipe/tx_build/", storeName),
		txbuilder.CreateRecipeTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/execute_recipe/tx_build/", storeName),
		txbuilder.ExecuteRecipeTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/update_recipe/tx_build/", storeName),
		txbuilder.UpdateRecipeTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/enable_recipe/tx_build/", storeName),
		txbuilder.EnableRecipeTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/disable_recipe/tx_build/", storeName),
		txbuilder.DisableRecipeTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons", storeName),
		getPylonsHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons", storeName),
		pylonsSendHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/addr_from_pub_key/{%s}", storeName, pubKeyName),
		addrFromPubkeyHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_recipies/{%s}", storeName, ownerKeyName),
		listRecipiesHandler(cdc, cliCtx, storeName)).Methods("GET")
}

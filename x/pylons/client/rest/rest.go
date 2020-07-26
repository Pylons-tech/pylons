package rest

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/client/rest/txbuilder"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"

	"github.com/gorilla/mux"
)

const (

	// DefaultCoinPerRequest is the number of coins the faucet sends per req
	DefaultCoinPerRequest = 500
	pubKeyName            = "pubkey"
	ownerKeyName          = "ownerKey"
	tradeKeyName          = "tradeKey"
	cookbookKeyName       = "cookbookKey"
	senderKey             = "senderKey"
)

// RegisterRoutes adds routes
func RegisterRoutes(cliCtx context.CLIContext, r *mux.Router, cdc *codec.Codec, storeName string) {
	r.HandleFunc(fmt.Sprintf("/%s/create_accounht/tx_build/{%s}", storeName, txbuilder.TxCARequesterKey),
		txbuilder.CreateAccountTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons/tx_build/{%s}", storeName, txbuilder.TxGPRequesterKey),
		txbuilder.GetPylonsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/google_iap_get_pylons/tx_build/{%s}", storeName, txbuilder.TxGoogleIAPGPRequesterKey),
		txbuilder.GoogleIAPGetPylonsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons/tx_build/", storeName),
		txbuilder.SendPylonsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_coins/tx_build/", storeName),
		txbuilder.SendCoinsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_items/tx_build/", storeName),
		txbuilder.SendItemsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
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
	r.HandleFunc(fmt.Sprintf("/%s/google_iap_get_pylons", storeName),
		googleIAPGetPylonsHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/create_account", storeName),
		createAccountHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/send_coins", storeName),
		coinsSendHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons", storeName),
		pylonsSendHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/addr_from_pub_key/{%s}", storeName, pubKeyName),
		addrFromPubkeyHandler(cdc, cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/get_trade/{%s}", storeName, tradeKeyName),
		getTradeHandler(cdc, cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/list_recipe", storeName),
		listRecipesHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_recipe/{%s}", storeName, ownerKeyName),
		listRecipesHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_shorten_recipe", storeName),
		listShortenRecipesHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_shorten_recipe/{%s}", storeName, ownerKeyName),
		listShortenRecipesHandler(cdc, cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/list_cookbooks", storeName),
		listCookbooksHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_cookbooks/{%s}", storeName, ownerKeyName),
		listCookbooksHandler(cdc, cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/list_trade", storeName),
		listTradesHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_trade/{%s}", storeName, ownerKeyName),
		listTradesHandler(cdc, cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/items_by_cookbook", storeName),
		itemsByCookbookHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/items_by_cookbook/{%s}", storeName, cookbookKeyName),
		itemsByCookbookHandler(cdc, cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/items_by_sender", storeName),
		itemsBySenderHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/items_by_sender/{%s}", storeName, senderKey),
		itemsBySenderHandler(cdc, cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/list_executions", storeName),
		listExecutionsHandler(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_executions/{%s}", storeName, senderKey),
		listExecutionsHandler(cdc, cliCtx, storeName)).Methods("GET")

}

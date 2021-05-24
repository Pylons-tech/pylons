package rest

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/client/rest/txbuilder"
	"github.com/cosmos/cosmos-sdk/client"

	"github.com/gorilla/mux"
)

const (

	// DefaultCoinPerRequest is the number of coins the faucet sends per req
	DefaultCoinPerRequest = 500
	pubKeyName            = "pubkey"
	purchaseTokenKey      = "purchaseTokenKey"
	paymentId             = "paymentId"
	ownerKeyName          = "ownerKey"
	tradeKeyName          = "tradeKey"
	cookbookKeyName       = "cookbookKey"
	senderKey             = "senderKey"
)

// RegisterRoutes adds routes
func RegisterRoutes(cliCtx client.Context, r *mux.Router, storeName string) {
	r.HandleFunc(fmt.Sprintf("/%s/create_accounht/tx_build/{%s}", storeName, txbuilder.TxCARequesterKey),
		txbuilder.CreateAccountTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons/tx_build/{%s}", storeName, txbuilder.TxGPRequesterKey),
		txbuilder.GetPylonsTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/google_iap_get_pylons/tx_build/{%s}", storeName, txbuilder.TxGoogleIAPGPRequesterKey),
		txbuilder.GoogleIAPGetPylonsTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/stripe_get_pylons/tx_build/{%s}", storeName, txbuilder.TxStripeGPRequesterKey),
		txbuilder.StripeGetPylonsTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons/tx_build/", storeName),
		txbuilder.SendPylonsTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_coins/tx_build/", storeName),
		txbuilder.SendCoinsTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_items/tx_build/", storeName),
		txbuilder.SendItemsTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/create_cookbook/tx_build/", storeName),
		txbuilder.CreateCookbookTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/update_cookbook/tx_build/", storeName),
		txbuilder.UpdateCookbookTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/create_recipe/tx_build/", storeName),
		txbuilder.CreateRecipeTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/execute_recipe/tx_build/", storeName),
		txbuilder.ExecuteRecipeTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/update_recipe/tx_build/", storeName),
		txbuilder.UpdateRecipeTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/enable_recipe/tx_build/", storeName),
		txbuilder.EnableRecipeTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/disable_recipe/tx_build/", storeName),
		txbuilder.DisableRecipeTxBuilder(cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons", storeName),
		getPylonsHandler(cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/google_iap_get_pylons", storeName),
		googleIAPGetPylonsHandler(cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/stripe_get_pylons", storeName),
		stripeGetPylonsHandler(cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/create_account", storeName),
		createAccountHandler(cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons", storeName),
		pylonsSendHandler(cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/send_coins", storeName),
		coinsSendHandler(cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/addr_from_pub_key/{%s}", storeName, pubKeyName),
		addrFromPubkeyHandler(cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/get_trade/{%s}", storeName, tradeKeyName),
		getTradeHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/check_google_iap_order/{%s}", storeName, purchaseTokenKey),
		checkGoogleIAPOrderHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/check_stripe_order/{%s}", storeName, paymentId),
		checkStripeOrderHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_recipe", storeName),
		listRecipesHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_recipe/{%s}", storeName, ownerKeyName),
		listRecipesHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_recipe_by_cookbook", storeName),
		listRecipesByCookbookHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_recipe_by_cookbook/{%s}", storeName, cookbookKeyName),
		listRecipesByCookbookHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_shorten_recipe", storeName),
		listShortenRecipesHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_shorten_recipe/{%s}", storeName, ownerKeyName),
		listShortenRecipesHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_shorten_recipe_by_cookbook", storeName),
		listShortenRecipesByCookbookHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_shorten_recipe_by_cookbook/{%s}", storeName, ownerKeyName),
		listShortenRecipesByCookbookHandler(cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/list_cookbooks", storeName),
		listCookbooksHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_cookbooks/{%s}", storeName, ownerKeyName),
		listCookbooksHandler(cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/list_trade", storeName),
		listTradesHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_trade/{%s}", storeName, ownerKeyName),
		listTradesHandler(cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/items_by_cookbook", storeName),
		itemsByCookbookHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/items_by_cookbook/{%s}", storeName, cookbookKeyName),
		itemsByCookbookHandler(cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/items_by_sender", storeName),
		itemsBySenderHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/items_by_sender/{%s}", storeName, senderKey),
		itemsBySenderHandler(cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/list_executions", storeName),
		listExecutionsHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/list_executions/{%s}", storeName, senderKey),
		listExecutionsHandler(cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/get_locked_coin_details", storeName),
		getLockedCoinDetailsHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/get_locked_coin_details/{%s}", storeName, senderKey),
		getLockedCoinDetailsHandler(cliCtx, storeName)).Methods("GET")

	r.HandleFunc(fmt.Sprintf("/%s/get_locked_coins", storeName),
		getLockedCoinsHandler(cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/get_locked_coins/{%s}", storeName, senderKey),
		getLockedCoinsHandler(cliCtx, storeName)).Methods("GET")
}

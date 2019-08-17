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
)

// RegisterRoutes adds routes
func RegisterRoutes(cliCtx context.CLIContext, r *mux.Router, cdc *codec.Codec, storeName string) {
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons/tx_build/{%s}", storeName, txbuilder.TxGPRequesterKey),
		txbuilder.GetPylonsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons/tx_build/", storeName),
		txbuilder.SendPylonsTxBuilder(cdc, cliCtx, storeName)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons", storeName),
		getPylonsHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons", storeName),
		pylonsSendHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/addr_from_pub_key/{%s}", storeName, pubKeyName),
		addrFromPubkeyHandler(cdc, cliCtx, storeName)).Methods("GET")
}

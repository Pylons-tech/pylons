package rest

import (
	"fmt"

	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"

	"github.com/gorilla/mux"
)

const (
	restName = "pylons"

	// DefaultCoinPerRequest is the number of coins the faucet sends per req
	DefaultCoinPerRequest = 500
)

// RegisterRoutes adds routes
func RegisterRoutes(cliCtx context.CLIContext, r *mux.Router, cdc *codec.Codec, storeName string) {
	r.HandleFunc(fmt.Sprintf("/%s/get_pylons", storeName), getPylonsHandler(cdc, cliCtx)).Methods("POST")
	r.HandleFunc(fmt.Sprintf("/%s/balance", storeName), pylonsBalanceHandler(cdc, cliCtx)).Methods("GET")
	r.HandleFunc(fmt.Sprintf("/%s/send_pylons", storeName), pylonsSendHandler(cdc, cliCtx)).Methods("POST")
}

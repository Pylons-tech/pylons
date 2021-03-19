package txbuilder

import (
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// query endpoints supported by the nameservice Querier
const (
	TxCARequesterKey = "ca_requester"
)

// CreateAccountTxBuilder returns the fixtures which can be used to create a get pylons transaction
func CreateAccountTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		addr, err := sdk.AccAddressFromBech32("cosmos10nlnguhl0xsctwff4ch9gyjdcetxa2eww46e29")
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}
		txf := tx.Factory{}.
			WithChainID("testing").
			WithTxConfig(cliCtx.TxConfig)

		msg := msgs.NewMsgCreateAccount(addr)

		cliCtx.Output = w
		err = tx.GenerateTx(cliCtx, txf, []sdk.Msg{&msg}...)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}
	}
}

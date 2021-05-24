package txbuilder

import (
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/gorilla/mux"
)

// query endpoints supported by the nameservice Querier
const (
	TxStripeGPRequesterKey = "stripe_gp_requester"
)

// StripeGetPylonsTxBuilder returns the fixtures which can be used to create a get pylons transaction
func StripeGetPylonsTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		requester := vars[TxGPRequesterKey]
		addr, err := sdk.AccAddressFromBech32(requester)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		msg := types.NewMsgStripeGetPylons(
			"your.product.id",
			"your.payment.id",
			"your.payment.method",
			"your.receipt.data",
			"your.puchase.signature",
			addr.String())

		txf := tx.Factory{}.
			WithChainID("testing").
			WithTxConfig(cliCtx.TxConfig)

		cliCtx.Output = w
		err = tx.GenerateTx(cliCtx, txf, []sdk.Msg{&msg}...)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}
	}
}

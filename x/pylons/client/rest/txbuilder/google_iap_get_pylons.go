package txbuilder

import (
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/gorilla/mux"
)

// query endpoints supported by the nameservice Querier
const (
	TxGoogleIAPGPRequesterKey = "google_iap_gp_requester"
)

// GoogleIAPGetPylonsTxBuilder returns the fixtures which can be used to create a get pylons transaction
func GoogleIAPGetPylonsTxBuilder(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		requester := vars[TxGPRequesterKey]
		addr, err := sdk.AccAddressFromBech32(requester)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		msg := msgs.NewMsgGoogleIAPGetPylons(
			"your.product.id",
			"your.purchase.token",
			"your.receipt.data",
			"your.puchase.signature",
			addr)

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

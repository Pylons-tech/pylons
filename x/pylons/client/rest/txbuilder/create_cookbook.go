package txbuilder

// this module provides the fixtures to build a transaction

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// CreateCookbookTxBuilder returns the fixtures which can be used to create a create cookbook transaction
func CreateCookbookTxBuilder(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// vars := mux.Vars(r)
		// requester := vars[TxGPRequesterKey]
		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		msg := msgs.NewMsgCreateCookbook(
			"name",
			"",
			"this has to meet character limits lol",
			"SketchyCo",
			&types.SemVer{"1.0.0"},
			&types.Email{"example@example.com"},
			&types.Level{0},
			msgs.DefaultCostPerBlock,
			sender,
		)

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

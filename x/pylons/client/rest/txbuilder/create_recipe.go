package txbuilder

// this module provides the fixtures to build a transaction

import (
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// CreateRecipeTxBuilder returns the fixtures which can be used to create a create cookbook transaction
func CreateRecipeTxBuilder(cliCtx client.Context, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// vars := mux.Vars(r)
		// requester := vars[TxGPRequesterKey]
		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		genCoinInputList := types.GenCoinInputList("wood", 5)
		genItemInputList := types.GenItemInputList("Raichu")
		genEntries := types.GenEntries("chair", "Raichu")
		genOneOutput := types.GenOneOutput("chair", "Raichu")

		msg := msgs.NewMsgCreateRecipe(
			"name",
			"id001",
			"",
			"this has to meet character limits lol",
			genCoinInputList,
			genItemInputList,
			genEntries,
			genOneOutput,
			0,
			sender.String(),
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

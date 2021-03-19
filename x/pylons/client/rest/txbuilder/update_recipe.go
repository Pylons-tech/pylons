package txbuilder

import (
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// UpdateRecipeTxBuilder returns the fixtures which can be used to create a update recipe transaction
func UpdateRecipeTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		genCoinInputList := types.GenCoinInputList("wood", 5)
		genItemInputList := types.GenItemInputList("Raichu")
		genEntries := types.GenEntries("chair", "Raichu")
		genOneOutput := types.GenOneOutput("chair", "Raichu")

		msg := msgs.NewMsgUpdateRecipe("id001", "recipeName", "name", "this has to meet character limits lol",
			genCoinInputList,
			genItemInputList,
			genEntries,
			genOneOutput,
			0,
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

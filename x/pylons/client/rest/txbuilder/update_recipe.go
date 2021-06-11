package txbuilder

import (
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// UpdateRecipeTxBuilder returns the fixtures which can be used to create a update recipe transaction
func UpdateRecipeTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sender, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		genCoinInputList := types.GenCoinInputList("wood", 5)
		genItemInputList := types.GenItemInputList("Raichu")
		genEntries := types.GenEntries("chair", "Raichu")
		genOneOutput := types.GenOneOutput("chair", "Raichu")

		msg := types.NewMsgUpdateRecipe("id001", "recipeName", "name", "this has to meet character limits lol",
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

package txbuilder

// this module provides the fixtures to build a transaction

import (
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// CreateRecipeTxBuilder returns the fixtures which can be used to create a create cookbook transaction
func CreateRecipeTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sender, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		genCoinInputList := types.GenCoinInputList("wood", 5)
		genItemInputList := types.GenItemInputList("Raichu")
		genEntries := types.GenEntries("chair", "Raichu")
		genOneOutput := types.GenOneOutput("chair", "Raichu")
		genSkuString := types.GenExtraInfo("stripe_sku_id", config.Config.StripeConfig.StripeSkuID)

		msg := types.NewMsgCreateRecipe(
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
			genSkuString,
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

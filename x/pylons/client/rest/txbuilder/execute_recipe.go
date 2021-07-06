package txbuilder

// this module provides the fixtures to build a transaction

import (
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// ExecuteRecipeTxBuilder returns the fixtures which can be used to create a execute recipe transaction
func ExecuteRecipeTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sender, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		msg := types.NewMsgExecuteRecipe("id0001", sender.String(), "pi_1DoShv2eZvKYlo2CqsROyFun", "pm_card_visa", []string{"alpha", "beta", "gamma"})

		//msg := types.NewMsgExecuteRecipe("id0001", sender.String(), types.PaymentInfo{"stripe", "pi_1DoShv2eZvKYlo2CqsROyFun", "pm_card_visa"}, []string{"alpha", "beta", "gamma"})

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

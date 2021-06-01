package txbuilder

// this module provides the fixtures to build a transaction

import (
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// ExecuteRecipeTxBuilder returns the fixtures which can be used to create a execute recipe transaction
func ExecuteRecipeTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}
		// payParams1 := types.GenPaymentParams("PaymentId", "pi_1DoShv2eZvKYlo2CqsROyFun")
		// payParams2 := types.GenPaymentParams("PaymentMethod", "pm_card_visa")
		payInfo := types.PaymentInfo{
			PayType:   "stripe",
			PayParams: []string{"pi_1DoShv2eZvKYlo2CqsROyFun", "pm_card_visa"},
		}
		msg := types.NewMsgExecuteRecipe("id0001", sender.String(), payInfo, []string{"alpha", "beta", "gamma"})

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

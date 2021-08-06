package txbuilder

// this module provides the fixtures to build a transaction

import (
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// StripeCreateSkuTxBuilder returns the fixtures which can be used to create a execute recipe transaction
func StripeCreateSkuTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		sender, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		inventory := types.StripeInventory{
			Quantity: 1,
			Type:     "finite",
			Value:    "Value",
		}

		msg := types.NewMsgStripeCreateSku(
			"Stripe_key",
			"Product_Id",
			types.StringKeyValueList{
				{
					Key:   "Key",
					Value: "Value",
				},
			},
			100, "USD", &inventory, sender.String())

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

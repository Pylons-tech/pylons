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

// StripeCheckoutTxBuilder returns the fixtures which can be used to create a execute recipe transaction
func StripeCheckoutTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		mStripePrice := types.GenMsgStripePrice("prod_JbDBZLI2tHV4Ly", "500", "USD")

		msg := types.NewMsgStripeCheckout("sk_test_4eC39HqLyjWDarjtT1zdp7dc", "pm_card_visa", &mStripePrice, sender.String())

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

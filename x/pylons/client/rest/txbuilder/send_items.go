package txbuilder

import (
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
)

// SendItemsTxBuilder returns the fixtures which can be used to create a send items transaction
func SendItemsTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sender, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		recv, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		itemIDs := []string{"cosmos1fdwv4q20wm0ar7y8q2ak8vxqup89n33sp4hp2q3d6b4e7b-5589-4a65-88ad-7262a75b9782", "cosmos1fdwv4q20wm0ar7y8q2ak8vxqup89n33sp4hp2qab539c55-d98a-4ede-9803-a36b93505bd6"}

		msg := types.NewMsgSendItems(itemIDs, sender.String(), recv.String())

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

package txbuilder

// this module provides the fixtures to build a transaction

import (
	"net/http"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/utils"
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	authtxb "github.com/cosmos/cosmos-sdk/x/auth/client/txbuilder"
)

// DisableRecipeTxBuilder returns the fixtures which can be used to create a disable recipe transaction
func DisableRecipeTxBuilder(cdc *codec.Codec, cliCtx context.CLIContext, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// vars := mux.Vars(r)
		// requester := vars[TxGPRequesterKey]
		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

		txBldr := authtxb.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc))

		msg := msgs.NewMsgDisableRecipe("id0001", sender)

		signMsg, err := txBldr.BuildSignMsg([]sdk.Msg{msg})

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		rest.PostProcessResponse(w, cdc, signMsg.Bytes(), cliCtx.Indent)
	}
}

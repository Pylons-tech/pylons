package txbuilder

import (
	"bytes"
	"net/http"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/cosmos/cosmos-sdk/x/auth"
	authclient "github.com/cosmos/cosmos-sdk/x/auth/client"
)

// UpdateRecipeTxBuilder returns the fixtures which can be used to create a update recipe transaction
func UpdateRecipeTxBuilder(cdc *codec.Codec, cliCtx context.CLIContext, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		sender, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

		txBldr := auth.NewTxBuilderFromCLI(&bytes.Buffer{}).WithTxEncoder(authclient.GetTxEncoder(cdc))

		msg := msgs.NewMsgUpdateRecipe("recipeName", "name", "id001", "this has to meet character limits lol",
			types.GenCoinInputList("wood", 5),
			types.GenItemInputList("Raichu"),
			types.GenEntries("chair", "Raichu"),
			types.GenOneOutput(2),
			sender,
		)

		signMsg, err := txBldr.BuildSignMsg([]sdk.Msg{msg})

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		rest.PostProcessResponse(w, cliCtx, signMsg.Bytes())
	}
}

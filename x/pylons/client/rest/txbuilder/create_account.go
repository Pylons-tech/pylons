package txbuilder

import (
	"bytes"
	"net/http"

	"encoding/hex"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"
	"github.com/gorilla/mux"
)

// query endpoints supported by the nameservice Querier
const (
	TxCARequesterKey = "ca_requester"
)

// CreateAccountTxBuilder returns the fixtures which can be used to create a get pylons transaction
func CreateAccountTxBuilder(cdc *codec.Codec, cliCtx context.CLIContext, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		requester := vars[TxCARequesterKey]
		addr, err := sdk.AccAddressFromBech32(requester)
		txBldr := auth.NewTxBuilderFromCLI(&bytes.Buffer{}).WithTxEncoder(utils.GetTxEncoder(cdc))

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		msg := msgs.NewMsgCreateAccount(addr)

		signMsg, err := txBldr.BuildSignMsg([]sdk.Msg{msg})

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		stdTx := auth.NewStdTx(signMsg.Msgs, signMsg.Fee, []auth.StdSignature{}, signMsg.Memo)
		gb := CATxBuilder{
			SignerBytes: hex.EncodeToString(signMsg.Bytes()),
			SignMsg:     signMsg,
			SignTx:      stdTx,
		}
		eGB, err := cdc.MarshalJSON(gb)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		rest.PostProcessResponse(w, cliCtx, eGB)
	}
}

// CATxBuilder gives all the necessary fixtures for creating a get pylons transaction
type CATxBuilder struct {
	SignMsg     auth.StdSignMsg
	SignTx      auth.StdTx
	SignerBytes string
}

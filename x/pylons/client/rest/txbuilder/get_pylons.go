package txbuilder

// this module provides the fixtures to build a transaction

import (
	"net/http"

	"encoding/hex"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/utils"
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/cosmos/cosmos-sdk/x/auth"
	authtxb "github.com/cosmos/cosmos-sdk/x/auth/client/txbuilder"
	"github.com/gorilla/mux"
)

// query endpoints supported by the nameservice Querier
const (
	TxGPRequesterKey = "gp_requester"
)

// GetPylonsTxBuilder returns the fixtures which can be used to create a get pylons transaction
func GetPylonsTxBuilder(cdc *codec.Codec, cliCtx context.CLIContext, storeName string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		requester := vars[TxGPRequesterKey]
		addr, err := sdk.AccAddressFromBech32(requester)
		txBldr := authtxb.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc))

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		msg := msgs.NewMsgGetPylons(types.NewPylon(500), addr)
		sigs := []auth.StdSignature{{}}

		signMsg, err := txBldr.BuildSignMsg([]sdk.Msg{msg})

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		stdTx := auth.NewStdTx(signMsg.Msgs, signMsg.Fee, sigs, signMsg.Memo)

		gb := GPTxBuilder{
			SignerBytes: hex.EncodeToString(msg.GetSignBytes()),
			MsgJSON:     stdTx,
		}
		eGB, err := cdc.MarshalJSON(gb)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		rest.PostProcessResponse(w, cdc, eGB, cliCtx.Indent)
	}
}

// GPTxBuilder gives all the necessary fixtures for creating a get pylons transaction
type GPTxBuilder struct {
	// MsgJSON is the transaction with nil signature
	MsgJSON     auth.StdTx
	SignerBytes string
}

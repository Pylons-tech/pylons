package txbuilder

// this module provides the fixtures to build a transaction

import (
	"fmt"
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
	crypto "github.com/tendermint/tendermint/crypto/secp256k1"
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

		// sigs := []auth.StdSignature{{}}

		signMsg, err := txBldr.BuildSignMsg([]sdk.Msg{msg})
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}
		privKey, err := GetPrivateKeyFromHex("a96e62ed3955e65be32703f12d87b6b5cf26039ecfa948dc5107a495418e5330")
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}
		signedBytes, err := privKey.Sign(signMsg.Bytes())
		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}
		signature := auth.StdSignature{
			PubKey:    privKey.PubKey(),
			Signature: signedBytes,
		}

		stdTx := auth.NewStdTx(signMsg.Msgs, signMsg.Fee, []auth.StdSignature{signature}, signMsg.Memo)
		gb := GPTxBuilder{
			SignerBytes: hex.EncodeToString(signMsg.Bytes()),
			SignMsg:     signMsg,
			SignTx:      stdTx,
		}
		eGB, err := cdc.MarshalJSON(gb)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		rest.PostProcessResponse(w, cdc, eGB, cliCtx.Indent)
	}
}

func GetPrivateKeyFromHex(hexKey string) (*crypto.PrivKeySecp256k1, error) {
	hexPrivKey := hexKey
	privKeyBytes, err := hex.DecodeString(hexPrivKey)
	if err != nil {
		return nil, err
	}
	var privKeyBytes32 [32]byte
	copy(privKeyBytes32[:], privKeyBytes)
	privKey := crypto.PrivKeySecp256k1(privKeyBytes32)
	if err != nil {
		fmt.Printf("error: \n %+v \n", err)
	}

	return &privKey, nil
}

// GPTxBuilder gives all the necessary fixtures for creating a get pylons transaction
type GPTxBuilder struct {
	// MsgJSON is the transaction with nil signature
	SignMsg     authtxb.StdSignMsg
	SignTx      auth.StdTx
	SignerBytes string
}

package txbuilder

import (
	"bytes"
	"fmt"
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
		txBldr := auth.NewTxBuilderFromCLI(&bytes.Buffer{}).WithTxEncoder(utils.GetTxEncoder(cdc))

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		msg := msgs.NewMsgGetPylons(
			"your.order.id",
			"your.package.name",
			"your.product.id",
			1526476218113,
			0,
			"your.purchase.token",
			"your.puchase.signature",
			addr)

		// sigs := []auth.StdSignature{{}}

		signMsg, err := txBldr.BuildSignMsg([]sdk.Msg{msg})

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
		}

		stdTx := auth.NewStdTx(signMsg.Msgs, signMsg.Fee, []auth.StdSignature{}, signMsg.Memo)
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

		rest.PostProcessResponse(w, cliCtx, eGB)
	}
}

// GetPrivateKeyFromHex get private key from hex
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
	SignMsg     auth.StdSignMsg
	SignTx      auth.StdTx
	SignerBytes string
}

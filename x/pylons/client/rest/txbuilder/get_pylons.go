package txbuilder

import (
	"fmt"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"net/http"

	"encoding/hex"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"
	"github.com/gorilla/mux"
	crypto "github.com/tendermint/tendermint/crypto/secp256k1"
)

// query endpoints supported by the nameservice Querier
const (
	TxGPRequesterKey = "gp_requester"
)

// GetPylonsTxBuilder returns the fixtures which can be used to create a get pylons transaction
func GetPylonsTxBuilder(cliCtx client.Context) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		requester := vars[TxGPRequesterKey]
		addr, err := sdk.AccAddressFromBech32(requester)

		if err != nil {
			rest.WriteErrorResponse(w, http.StatusBadRequest, err.Error())
			return
		}

		msg := msgs.NewMsgGetPylons(types.NewPylon(500), addr)
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

// GetPrivateKeyFromHex get private key from hex
func GetPrivateKeyFromHex(hexKey string) (*crypto.PrivKey, error) {
	hexPrivKey := hexKey
	privKeyBytes, err := hex.DecodeString(hexPrivKey)
	if err != nil {
		return nil, err
	}
	var privKeyBytes32 []byte
	copy(privKeyBytes32[:], privKeyBytes)
	privKey := crypto.GenPrivKeySecp256k1(privKeyBytes32)
	if err != nil {
		fmt.Printf("error: \n %+v \n", err)
	}

	return &privKey, nil
}

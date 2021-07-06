package txbuilder

import (
	"net/http"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"encoding/hex"

	"github.com/gorilla/mux"
	crypto "github.com/tendermint/tendermint/crypto/secp256k1"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/rest"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

const (
	// TxGPRequesterKey is a query endpoint supported by the nameservice Querier
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

		msg := types.NewMsgGetPylons(types.NewPylon(500), addr.String())
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

	return &privKey, nil
}

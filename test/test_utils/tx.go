package inttest

import (
	"bytes"
	"fmt"
	"os"
	"sync"

	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"

	"github.com/spf13/viper"
)

var nonceMux sync.Mutex

func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

// GenTxWithMsg is a function to generate transaction from msg
func GenTxWithMsg(messages []sdk.Msg) (auth.StdTx, error) {
	var err error
	for i, msg := range messages {
		if err = msg.ValidateBasic(); err != nil {
			return auth.StdTx{}, fmt.Errorf("%dth msg does not pass basic validation for %s", i, err.Error())
		}
	}
	cdc := GetAminoCdc()
	cliCtx := context.NewCLIContext().WithCodec(cdc)

	viper.Set("keyring-backend", "test")
	viper.Set("chain-id", "pylonschain")

	txBldr := auth.NewTxBuilderFromCLI(&bytes.Buffer{}).WithTxEncoder(utils.GetTxEncoder(cdc)).WithChainID("pylonschain")
	if txBldr.SimulateAndExecute() {
		txBldr, err = utils.EnrichWithGas(txBldr, cliCtx, messages)
		if err != nil {
			return auth.StdTx{}, err
		}
	}

	stdSignMsg, err := txBldr.BuildSignMsg(messages)
	if err != nil {
		return auth.StdTx{}, err
	}
	stdSignMsg.Fee.Gas = 10000000

	return auth.NewStdTx(stdSignMsg.Msgs, stdSignMsg.Fee, nil, stdSignMsg.Memo), nil
}

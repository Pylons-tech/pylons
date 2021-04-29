package tx

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/cosmos/cosmos-sdk/client/input"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authclient "github.com/cosmos/cosmos-sdk/x/auth/client"
)

// ReadFile return bytes after reading a file
func ReadFile(fileURL string) ([]byte, error) {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		return []byte{}, err
	}

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue, nil
}

// GenerateOrBroadcastMsgs is customized from utils.GenerateOrBroadcastMsgs
func GenerateOrBroadcastMsgs(cliCtx client.Context, txBldr tx.Factory, msgs ...sdk.Msg) error {
	if cliCtx.GenerateOnly {
		return authclient.PrintUnsignedStdTx(txBldr, cliCtx, msgs)
	}

	return CompleteAndBroadcastTxCLI(txBldr, cliCtx, msgs...)
}

// CompleteAndBroadcastTxCLI is customized from utils.CompleteAndBroadcastTxCLI
func CompleteAndBroadcastTxCLI(txf tx.Factory, clientCtx client.Context, msgs ...sdk.Msg) error {

	if txf.SimulateAndExecute() || clientCtx.Simulate {
		_, adjusted, err := tx.CalculateGas(clientCtx.QueryWithData, txf, msgs...)
		if err != nil {
			return err
		}

		txf = txf.WithGas(adjusted)
		gasEst := tx.GasEstimateResponse{GasEstimate: txf.Gas()}
		_, _ = fmt.Fprintf(os.Stderr, "%s\n", gasEst.String())
	}

	if clientCtx.Simulate {
		return nil
	}

	txs, err := tx.BuildUnsignedTx(txf, msgs...)
	if err != nil {
		return err
	}

	if !clientCtx.SkipConfirm {
		out, err := clientCtx.TxConfig.TxJSONEncoder()(txs.GetTx())
		if err != nil {
			return err
		}

		_, _ = fmt.Fprintf(os.Stderr, "%s\n\n", out)
		buf := bufio.NewReader(os.Stdin)
		ok, err := input.GetConfirmation("confirm transaction before signing and broadcasting", buf, os.Stderr)
		if err != nil || !ok {
			_, _ = fmt.Fprintf(os.Stderr, "%s\n", "cancelled transaction")
			return err
		}
	}

	err = tx.Sign(txf, clientCtx.GetFromName(), txs, true)
	if err != nil {
		return err
	}

	txBytes, err := clientCtx.TxConfig.TxEncoder()(txs.GetTx())
	if err != nil {
		return err
	}

	// broadcast to a Tendermint node
	res, err := clientCtx.BroadcastTx(txBytes)
	if err != nil {
		return err
	}

	return clientCtx.PrintProto(res)
}

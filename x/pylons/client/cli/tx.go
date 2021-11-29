package cli

import (
	"bufio"
	"fmt"
	"os"
	"time"

	"github.com/cosmos/cosmos-sdk/client/input"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	// "github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var (
	DefaultRelativePacketTimeoutTimestamp = uint64((time.Duration(10) * time.Minute).Nanoseconds())
)

const (
	// nolint: deadcode, unused
	flagPacketTimeoutTimestamp = "packet-timeout-timestamp"
)

// GetTxCmd returns the transaction commands for this module
func GetTxCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:                        types.ModuleName,
		Short:                      fmt.Sprintf("%s transactions subcommands", types.ModuleName),
		DisableFlagParsing:         true,
		SuggestionsMinimumDistance: 2,
		RunE:                       client.ValidateCmd,
	}

	cmd.AddCommand(CmdEnlistForArena())
	// this line is used by starport scaffolding # 1
	cmd.AddCommand(CmdBurnDebtToken())

	cmd.AddCommand(CmdUpdateAccount())

	cmd.AddCommand(CmdFulfillTrade())

	cmd.AddCommand(CmdCreateTrade())

	cmd.AddCommand(CmdCancelTrade())

	cmd.AddCommand(CmdCompleteExecutionEarly())

	cmd.AddCommand(CmdTransferCookbook())

	cmd.AddCommand(CmdGoogleInAppPurchaseGetCoins())

	cmd.AddCommand(CmdCreateAccount())

	cmd.AddCommand(CmdSendItems())

	cmd.AddCommand(CmdExecuteRecipe())

	cmd.AddCommand(CmdSetItemString())

	cmd.AddCommand(CmdCreateRecipe())
	cmd.AddCommand(CmdUpdateRecipe())

	cmd.AddCommand(CmdCreateCookbook())
	cmd.AddCommand(CmdUpdateCookbook())

	cmd.AddCommand(CmdGenerateSignedAPIToken())

	return cmd
}

// GenerateOrBroadcastMsgs is customized from utils.GenerateOrBroadcastMsgs
func GenerateOrBroadcastMsgs(cliCtx client.Context, txBldr tx.Factory, msgs ...sdk.Msg) error {
	if cliCtx.GenerateOnly {
		return fmt.Errorf("cannot run cli cmd in GenerateOnly mode")
	}

	return CustomCompleteAndBroadcastTxCLI(txBldr, cliCtx, msgs...)
}

// CustomCompleteAndBroadcastTxCLI is a custom tx
func CustomCompleteAndBroadcastTxCLI(txf tx.Factory, clientCtx client.Context, msgs ...sdk.Msg) error {
	if txf.SimulateAndExecute() || clientCtx.Simulate {
		_, adjusted, err := tx.CalculateGas(clientCtx, txf, msgs...)
		if err != nil {
			return err
		}

		txf = txf.WithGas(adjusted)
		_, _ = fmt.Fprintf(os.Stderr, "%s\n", tx.GasEstimateResponse{GasEstimate: txf.Gas()})
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

	txs.SetFeeGranter(clientCtx.GetFeeGranterAddress())
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

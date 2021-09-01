package cli

import (
	"encoding/json"
	"strconv"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdFulfillTrade() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "fulfill-trade [id] [items]",
		Short: "fulfill an existing trade",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsId := args[0]
			argsItems := args[1]
			jsonArgsItems := make([]types.ItemRef, 0)
			err := json.Unmarshal([]byte(argsItems), &jsonArgsItems)
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgFulfillTrade(clientCtx.GetFromAddress().String(), argsId, jsonArgsItems)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

package cli

import (
	"encoding/json"
	"github.com/spf13/cast"
	"strconv"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdSendItems() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "send-items [receiver] [items]",
		Short: "send items to receiver",
		Args:  cobra.ExactArgs(3),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsReceiver := args[0]

			argsItems, err := cast.ToStringE(args[1])
			if err != nil {
				return err
			}
			jsonArgsItems := make([]types.ItemRef, 0)
			err = json.Unmarshal([]byte(argsItems), &jsonArgsItems)
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgSendItems(clientCtx.GetFromAddress().String(), argsReceiver, jsonArgsItems)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

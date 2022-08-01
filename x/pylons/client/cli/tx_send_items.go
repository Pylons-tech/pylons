package cli

import (
	"encoding/json"
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ = strconv.Itoa(0)

func CmdSendItems() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "send-items [receiver] [items]",
		Short: "send items to receiver",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsReceiver := args[0]

			argsItems := args[1]
			jsonArgsItems := make([]v1beta1.ItemRef, 0)
			err := json.Unmarshal([]byte(argsItems), &jsonArgsItems)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := v1beta1.NewMsgSendItems(clientCtx.GetFromAddress().String(), argsReceiver, jsonArgsItems)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

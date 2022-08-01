package cli

import (
	"encoding/json"
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/spf13/cast"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
)

var _ = strconv.Itoa(0)

func CmdFulfillTrade() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "fulfill-trade [id] [coin-inputs-index] [items] [payment-info]",
		Short: "fulfill existing trade",
		Args:  cobra.ExactArgs(4),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsID, err := cast.ToUint64E(args[0])
			if err != nil {
				return err
			}
			argsCoinInputsIndex, err := cast.ToUint64E(args[1])
			if err != nil {
				return err
			}
			argsItems := args[2]
			jsonArgsItems := make([]v1beta1.ItemRef, 0)
			err = json.Unmarshal([]byte(argsItems), &jsonArgsItems)
			if err != nil {
				return err
			}
			argsPaymentInfo := args[3]
			jsonArgsPaymentInfo := make([]v1beta1.PaymentInfo, 0)
			err = json.Unmarshal([]byte(argsPaymentInfo), &jsonArgsPaymentInfo)
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := v1beta1.NewMsgFulfillTrade(clientCtx.GetFromAddress().String(), argsID, argsCoinInputsIndex, jsonArgsItems, jsonArgsPaymentInfo)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

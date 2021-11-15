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

func CmdBurnDebtToken() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "burn-debt-token [redeemInfo]",
		Short: "burn debt token using redeem confirmation receipt",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsRedeemInfo := args[0]
			var jsonArgsRedeemInfo types.RedeemInfo
			err := json.Unmarshal([]byte(argsRedeemInfo), &jsonArgsRedeemInfo)
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgBurnDebtToken(clientCtx.GetFromAddress().String(), jsonArgsRedeemInfo)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

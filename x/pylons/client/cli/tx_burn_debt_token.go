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

func CmdBurnDebtToken() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "burn-debt-token [redeemInfo]",
		Short: "burn debt token using redeem confirmation receipt",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsRedeemInfo := args[0]
			var jsonArgsRedeemInfo v1beta1.RedeemInfo
			err := json.Unmarshal([]byte(argsRedeemInfo), &jsonArgsRedeemInfo)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := v1beta1.NewMsgBurnDebtToken(clientCtx.GetFromAddress().String(), jsonArgsRedeemInfo)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

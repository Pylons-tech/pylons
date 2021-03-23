package tx

import (
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"github.com/spf13/cobra"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

const (
	// DefaultCoinPerRequest is the number of coins that will be sent per faucet request
	DefaultCoinPerRequest = 500
)

// GetPylons implements GetPylons msg transaction
func GetPylons() *cobra.Command {
	var customBalance int64
	cmd := &cobra.Command{
		Use:   "get-pylons",
		Short: "ask for pylons. 500 default pylons per request",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := &msgs.MsgGetPylons{
				Amount:    types.NewPylon(customBalance),
				Requester: clientCtx.GetFromAddress().String(),
			}
			err = msg.ValidateBasic()
			if err != nil {
				return err
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{msg}...)
		},
	}
	flags.AddTxFlagsToCmd(cmd)
	cmd.PersistentFlags().Int64Var(&customBalance, "amount", DefaultCoinPerRequest, "The request pylon amount")
	return cmd
}

package tx

import (
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// UpdateCookbook is the client cli command for creating cookbook
func UpdateCookbook() *cobra.Command {

	var msgCCB = &types.MsgUpdateCookbook{}
	var tmpVersion string
	var tmpEmail string

	cmd := &cobra.Command{
		Use:   "update-cookbook [args]",
		Short: "update cookbook by providing the args",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msgCCB.Sender = clientCtx.GetFromAddress().String()
			msgCCB.Version = tmpVersion
			msgCCB.SupportEmail = tmpEmail

			err = msgCCB.ValidateBasic()
			if err != nil {
				return err
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{msgCCB}...)
		},
	}

	flags.AddTxFlagsToCmd(cmd)
	cmd.PersistentFlags().StringVar(&msgCCB.Description, "desc", "", "The description for the cookbook")
	cmd.PersistentFlags().StringVar(&msgCCB.Developer, "developer", "", "The developer of the cookbook")
	cmd.PersistentFlags().StringVar(&tmpEmail, "email", "", "The support email")
	cmd.PersistentFlags().StringVar(&tmpVersion, "version", "", "The version of the cookbook")

	return cmd
}

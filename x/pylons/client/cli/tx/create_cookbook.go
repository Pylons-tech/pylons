package tx

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// CreateCookbook is the client cli command for creating cookbook
func CreateCookbook() *cobra.Command {

	var msgCCB = &types.MsgCreateCookbook{}

	cmd := &cobra.Command{
		Use:   "create-cookbook [args]",
		Short: "create cookbook by providing the args",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			// This command is automatically setting the sender with --from address
			// If we set level, version, support_email, tmp_level name and description separately,
			// it can be very complex, especially for other commands like create_recipe, fiat_item

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			byteValue, err := ReadFile(args[0])
			if err != nil {
				return err
			}
			err = json.Unmarshal(byteValue, &msgCCB)
			if err != nil {
				return err
			}

			msgCCB.Sender = clientCtx.GetFromAddress().String()

			err = msgCCB.ValidateBasic()
			if err != nil {
				return err
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{msgCCB}...)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

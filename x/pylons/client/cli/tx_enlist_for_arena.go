package cli

import (
	"strconv"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
)

var _ = strconv.Itoa(0)

func CmdEnlistForArena() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "enlist-for-arena [opponent] [cookbook-id] [l-hitem] [r-hitem] [armoritem]",
		Short: "Broadcast message EnlistForArena",
		Args:  cobra.ExactArgs(5),
		RunE: func(cmd *cobra.Command, args []string) (err error) {
			argOpponent := args[0]
			argCookbookID := args[1]
			argLHitem := args[2]
			argRHitem := args[3]
			argArmoritem := args[4]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgEnlistForArena(
				clientCtx.GetFromAddress().String(),
				argOpponent,
				argCookbookID,
				argLHitem,
				argRHitem,
				argArmoritem,
			)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

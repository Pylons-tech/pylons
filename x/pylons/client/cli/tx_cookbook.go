package cli

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdCreateCookbook() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-cookbook [id] [name] [description] [developer] [version] [support-email] [enabled]",
		Short: "create new cookbook",
		Args:  cobra.ExactArgs(7),
		RunE: func(cmd *cobra.Command, args []string) error {
			id := args[0]
			argsName := args[1]
			argsDescription := args[2]
			argsDeveloper := args[3]
			argsVersion := args[4]
			argsSupportEmail := args[5]

			argsEnabled, err := cast.ToBoolE(args[6])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateCookbook(clientCtx.GetFromAddress().String(), id, argsName, argsDescription, argsDeveloper, argsVersion, argsSupportEmail, argsEnabled)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func CmdUpdateCookbook() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "update-cookbook [id] [name] [description] [developer] [version] [support-email] [cost-per-block] [enabled]",
		Short: "update cookbook",
		Args:  cobra.ExactArgs(7),
		RunE: func(cmd *cobra.Command, args []string) error {
			id := args[0]
			argsName := args[1]
			argsDescription := args[2]
			argsDeveloper := args[3]
			argsVersion := args[4]
			argsSupportEmail := args[5]

			argsEnabled, err := cast.ToBoolE(args[6])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgUpdateCookbook(clientCtx.GetFromAddress().String(), id, argsName, argsDescription, argsDeveloper, argsVersion, argsSupportEmail, argsEnabled)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

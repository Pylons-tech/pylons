package cli

import (
	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
)

func CmdCreateCookbook() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-cookbook [index] [nodeVersion] [name] [description] [developer] [version] [supportEmail] [level] [costPerBlock]",
		Short: "Create a new Cookbook",
		Args:  cobra.ExactArgs(9),
		RunE: func(cmd *cobra.Command, args []string) error {
			index := args[0]
			argsNodeVersion, err := cast.ToStringE(args[1])
			if err != nil {
				return err
			}
			argsName, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			argsDescription, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			argsDeveloper, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}
			argsVersion, err := cast.ToStringE(args[5])
			if err != nil {
				return err
			}
			argsSupportEmail, err := cast.ToStringE(args[6])
			if err != nil {
				return err
			}
			argsLevel, err := cast.ToInt64E(args[7])
			if err != nil {
				return err
			}
			argsCostPerBlock, err := cast.ToUint64E(args[8])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateCookbook(clientCtx.GetFromAddress().String(), index, argsNodeVersion, argsName, argsDescription, argsDeveloper, argsVersion, argsSupportEmail, argsLevel, argsCostPerBlock)
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
		Use:   "update-cookbook [index] [nodeVersion] [name] [description] [developer] [version] [supportEmail] [level] [costPerBlock] [enabled]",
		Short: "Update a Cookbook",
		Args:  cobra.ExactArgs(10),
		RunE: func(cmd *cobra.Command, args []string) error {
			index := args[0]

			argsNodeVersion, err := cast.ToStringE(args[1])
			if err != nil {
				return err
			}
			argsName, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			argsDescription, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			argsDeveloper, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}
			argsVersion, err := cast.ToStringE(args[5])
			if err != nil {
				return err
			}
			argsSupportEmail, err := cast.ToStringE(args[6])
			if err != nil {
				return err
			}
			argsLevel, err := cast.ToInt64E(args[7])
			if err != nil {
				return err
			}
			argsCostPerBlock, err := cast.ToUint64E(args[8])
			if err != nil {
				return err
			}
			argsEnabled, err := cast.ToBoolE(args[9])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgUpdateCookbook(clientCtx.GetFromAddress().String(), index, argsNodeVersion, argsName, argsDescription, argsDeveloper, argsVersion, argsSupportEmail, argsLevel, argsCostPerBlock, argsEnabled)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

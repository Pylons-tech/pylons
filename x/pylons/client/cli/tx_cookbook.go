package cli

import (
	"encoding/json"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdCreateCookbook() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-cookbook [id] [name] [description] [developer] [version] [support-email] [cost-per-block] [enabled]",
		Short: "create new cookbook",
		Args:  cobra.ExactArgs(8),
		RunE: func(cmd *cobra.Command, args []string) error {
			id := args[0]
			argsName, err := cast.ToStringE(args[1])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsDescription, err := cast.ToStringE(args[2])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsDeveloper, err := cast.ToStringE(args[3])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsVersion, err := cast.ToStringE(args[4])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsSupportEmail, err := cast.ToStringE(args[5])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsCostPerBlock := args[6]
			jsonArgsCostPerBlock := sdk.Coin{}
			err = json.Unmarshal([]byte(argsCostPerBlock), &jsonArgsCostPerBlock)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsEnabled, err := cast.ToBoolE(args[7])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			msg := types.NewMsgCreateCookbook(clientCtx.GetFromAddress().String(), id, argsName, argsDescription, argsDeveloper, argsVersion, argsSupportEmail, jsonArgsCostPerBlock, argsEnabled)
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
		Args:  cobra.ExactArgs(8),
		RunE: func(cmd *cobra.Command, args []string) error {
			id := args[0]
			argsName, err := cast.ToStringE(args[1])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsDescription, err := cast.ToStringE(args[2])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsDeveloper, err := cast.ToStringE(args[3])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsVersion, err := cast.ToStringE(args[4])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsSupportEmail, err := cast.ToStringE(args[5])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsCostPerBlock := args[6]
			jsonArgsCostPerBlock := sdk.Coin{}
			err = json.Unmarshal([]byte(argsCostPerBlock), &jsonArgsCostPerBlock)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsEnabled, err := cast.ToBoolE(args[7])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			msg := types.NewMsgUpdateCookbook(clientCtx.GetFromAddress().String(), id, argsName, argsDescription, argsDeveloper, argsVersion, argsSupportEmail, jsonArgsCostPerBlock, argsEnabled)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

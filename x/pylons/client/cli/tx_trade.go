package cli

import (
	"encoding/json"
	"strconv"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdCreateTrade() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-trade [coinInputs] [itemInputs] [coinOutputs] [itemOutputs] [extraInfo]",
		Short: "create new trade",
		Args:  cobra.ExactArgs(5),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCoinInputs := args[0]
			jsonArgsCoinInputs, err := types.ParseCoinInputsCLI(argsCoinInputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsItemInputs := args[1]
			jsonArgsItemInputs := make([]types.ItemInput, 0)
			err = json.Unmarshal([]byte(argsItemInputs), &jsonArgsItemInputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsCoinOutput := args[2]
			jsonArgsCoinOutput, err := types.ParseCoinOutputCLI(argsCoinOutput)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsItemOutputs := args[3]
			jsonArgsItemOutputs := make([]types.ItemRef, 0)
			err = json.Unmarshal([]byte(argsItemOutputs), &jsonArgsItemOutputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsExtraInfo := args[4]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateTrade(clientCtx.GetFromAddress().String(), jsonArgsCoinInputs, jsonArgsItemInputs, jsonArgsCoinOutput, jsonArgsItemOutputs, argsExtraInfo)
			if err := msg.ValidateBasic(); err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func CmdCancelTrade() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "cancel-trade [id]",
		Short: "cancel a trade by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			id, err := strconv.ParseUint(args[0], 10, 64)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCancelTrade(clientCtx.GetFromAddress().String(), id)
			if err := msg.ValidateBasic(); err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

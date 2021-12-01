package cli

import (
	"encoding/json"
	"strconv"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdCreateTrade() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-trade [coinInputs] [itemInputs] [coinOutputs] [itemOutputs] [extraInfo]",
		Short: "create new trade",
		Args:  cobra.ExactArgs(5),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCoinInputs, err := cast.ToStringE(args[0])
			if err != nil {
				return err
			}
			jsonArgsCoinInputs := make([]types.CoinInput, 0)
			err = json.Unmarshal([]byte(argsCoinInputs), &jsonArgsCoinInputs)
			if err != nil {
				return err
			}
			argsItemInputs, err := cast.ToStringE(args[1])
			if err != nil {
				return err
			}
			jsonArgsItemInputs := make([]types.ItemInput, 0)
			err = json.Unmarshal([]byte(argsItemInputs), &jsonArgsItemInputs)
			if err != nil {
				return err
			}
			argsCoinOutput, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			jsonArgsCoinOutput := sdk.Coins{}
			err = json.Unmarshal([]byte(argsCoinOutput), &jsonArgsCoinOutput)
			if err != nil {
				return err
			}
			argsItemOutputs, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			jsonArgsItemOutputs := make([]types.ItemRef, 0)
			err = json.Unmarshal([]byte(argsItemOutputs), &jsonArgsItemOutputs)
			if err != nil {
				return err
			}
			argsExtraInfo, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			// TODO ras -> use cosmoscoin
			msg := types.NewMsgCreateTrade(clientCtx.GetFromAddress().String(), jsonArgsCoinInputs, jsonArgsItemInputs, jsonArgsCoinOutput, jsonArgsItemOutputs, argsExtraInfo)
			if err := msg.ValidateBasic(); err != nil {
				return err
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
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCancelTrade(clientCtx.GetFromAddress().String(), id)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

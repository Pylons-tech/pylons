package cli

import (
	"encoding/json"

	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdCreateRecipe() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-recipe [cookbook-id] [id] [name] [description] [version] [coin-inputs] [item-inputs] [entries] [outputs] [block-interval] [cost-per-block] [enabled] [extra-info]",
		Short: "create new recipe",
		Args:  cobra.ExactArgs(13),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCookbookID := args[0]
			id := args[1]
			argsName := args[2]
			argsDescription := args[3]
			argsVersion := args[4]

			argsCoinInputs := args[5]
			jsonArgsCoinInputs, err := types.ParseCoinInputsCLI(argsCoinInputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsItemInputs := args[6]
			jsonArgsItemInputs := make([]types.ItemInput, 0)
			err = json.Unmarshal([]byte(argsItemInputs), &jsonArgsItemInputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsEntries := args[7]
			jsonArgsEntries := types.EntriesList{}
			err = json.Unmarshal([]byte(argsEntries), &jsonArgsEntries)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsOutputs := args[8]
			jsonArgsOutputs := make([]types.WeightedOutputs, 0)
			err = json.Unmarshal([]byte(argsOutputs), &jsonArgsOutputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsBlockInterval, err := cast.ToInt64E(args[9])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsCostPerBlock := args[10]
			jsonArgsCostPerBlock, err := types.ParseCoinCLI(argsCostPerBlock)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsEnabled, err := cast.ToBoolE(args[11])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsExtraInfo := args[12]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateRecipe(clientCtx.GetFromAddress().String(), argsCookbookID, id, argsName, argsDescription, argsVersion, jsonArgsCoinInputs, jsonArgsItemInputs, jsonArgsEntries, jsonArgsOutputs, argsBlockInterval, jsonArgsCostPerBlock, argsEnabled, argsExtraInfo)
			if err := msg.ValidateBasic(); err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func CmdUpdateRecipe() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "update-recipe [cookbook-id] [id] [name] [description] [version] [coinInputs] [itemInputs] [entries] [outputs] [blockInterval] [cost-per-block] [enabled] [extraInfo]",
		Short: "update recipe",
		Args:  cobra.ExactArgs(13),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCookbookID := args[0]
			id := args[1]
			argsName := args[2]
			argsDescription := args[3]
			argsVersion := args[4]

			argsCoinInputs := args[5]
			jsonArgsCoinInputs, err := types.ParseCoinInputsCLI(argsCoinInputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsItemInputs := args[6]
			jsonArgsItemInputs := make([]types.ItemInput, 0)
			err = json.Unmarshal([]byte(argsItemInputs), &jsonArgsItemInputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsEntries := args[7]
			jsonArgsEntries := types.EntriesList{}
			err = json.Unmarshal([]byte(argsEntries), &jsonArgsEntries)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsOutputs := args[8]
			jsonArgsOutputs := make([]types.WeightedOutputs, 0)
			err = json.Unmarshal([]byte(argsOutputs), &jsonArgsOutputs)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsBlockInterval, err := cast.ToInt64E(args[9])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			argsCostPerBlock := args[10]
			jsonArgsCostPerBlock, err := types.ParseCoinCLI(argsCostPerBlock)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsEnabled, err := cast.ToBoolE(args[11])
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsExtraInfo := args[12]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgUpdateRecipe(clientCtx.GetFromAddress().String(), argsCookbookID, id, argsName, argsDescription, argsVersion, jsonArgsCoinInputs, jsonArgsItemInputs, jsonArgsEntries, jsonArgsOutputs, argsBlockInterval, jsonArgsCostPerBlock, argsEnabled, argsExtraInfo)
			if err := msg.ValidateBasic(); err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

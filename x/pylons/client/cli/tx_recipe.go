package cli

import (
	"encoding/json"

	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdCreateRecipe() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-recipe [cookbook-id] [id] [name] [description] [version] [coin-inputs] [item-inputs] [entries] [outputs] [block-interval] [cost-per-block] [enabled] [extra-info]",
		Short: "create new recipe",
		Args:  cobra.ExactArgs(13),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCookbookID, err := cast.ToStringE(args[0])
			if err != nil {
				return err
			}
			id := args[1]
			argsName, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			argsDescription, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			argsVersion, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}
			argsCoinInputs, err := cast.ToStringE(args[5])
			if err != nil {
				return err
			}
			jsonArgsCoinInputs := make([]types.CoinInput, 1)
			coins, err := ParseCoinArguments(argsCoinInputs)
			if err != nil {
				return err
			}
			jsonArgsCoinInputs[0].Coins = coins
			if err != nil {
				return err
			}

			argsItemInputs, err := cast.ToStringE(args[6])
			if err != nil {
				return err
			}
			jsonArgsItemInputs := make([]types.ItemInput, 0)
			err = json.Unmarshal([]byte(argsItemInputs), &jsonArgsItemInputs)
			if err != nil {
				return err
			}
			argsEntries, err := cast.ToStringE(args[7])
			if err != nil {
				return err
			}
			jsonArgsEntries := types.EntriesList{}
			err = json.Unmarshal([]byte(argsEntries), &jsonArgsEntries)
			if err != nil {
				return err
			}
			argsOutputs, err := cast.ToStringE(args[8])
			if err != nil {
				return err
			}
			jsonArgsOutputs := make([]types.WeightedOutputs, 0)
			err = json.Unmarshal([]byte(argsOutputs), &jsonArgsOutputs)
			if err != nil {
				return err
			}
			argsBlockInterval, err := cast.ToInt64E(args[9])
			if err != nil {
				return err
			}
			argsCostPerBlock := args[10]
			cArr, err := ParseCoinArguments(argsCostPerBlock)
			if err != nil {
				return err
			}
			jsonArgsCostPerBlock := cArr[0]
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsEnabled, err := cast.ToBoolE(args[11])
			if err != nil {
				return err
			}
			argsExtraInfo, err := cast.ToStringE(args[12])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateRecipe(clientCtx.GetFromAddress().String(), argsCookbookID, id, argsName, argsDescription, argsVersion, jsonArgsCoinInputs, jsonArgsItemInputs, jsonArgsEntries, jsonArgsOutputs, argsBlockInterval, jsonArgsCostPerBlock, argsEnabled, argsExtraInfo)
			if err := msg.ValidateBasic(); err != nil {
				return err
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
			argsCookbookID, err := cast.ToStringE(args[0])
			if err != nil {
				return err
			}
			id := args[1]
			argsName, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			argsDescription, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			argsVersion, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}
			argsCoinInputs, err := cast.ToStringE(args[5])
			if err != nil {
				return err
			}
			jsonArgsCoinInputs := make([]types.CoinInput, 0)
			err = json.Unmarshal([]byte(argsCoinInputs), &jsonArgsCoinInputs)
			if err != nil {
				return err
			}
			argsItemInputs, err := cast.ToStringE(args[6])
			if err != nil {
				return err
			}
			jsonArgsItemInputs := make([]types.ItemInput, 0)
			err = json.Unmarshal([]byte(argsItemInputs), &jsonArgsItemInputs)
			if err != nil {
				return err
			}
			argsEntries, err := cast.ToStringE(args[7])
			if err != nil {
				return err
			}
			jsonArgsEntries := types.EntriesList{}
			err = json.Unmarshal([]byte(argsEntries), &jsonArgsEntries)
			if err != nil {
				return err
			}
			argsOutputs, err := cast.ToStringE(args[8])
			if err != nil {
				return err
			}
			jsonArgsOutputs := make([]types.WeightedOutputs, 0)
			err = json.Unmarshal([]byte(argsOutputs), &jsonArgsOutputs)
			if err != nil {
				return err
			}
			argsBlockInterval, err := cast.ToInt64E(args[9])
			if err != nil {
				return err
			}
			argsCostPerBlock := args[10]
			jsonArgsCostPerBlock := sdk.Coin{}
			err = json.Unmarshal([]byte(argsCostPerBlock), &jsonArgsCostPerBlock)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			argsEnabled, err := cast.ToBoolE(args[11])
			if err != nil {
				return err
			}
			argsExtraInfo, err := cast.ToStringE(args[12])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgUpdateRecipe(clientCtx.GetFromAddress().String(), argsCookbookID, id, argsName, argsDescription, argsVersion, jsonArgsCoinInputs, jsonArgsItemInputs, jsonArgsEntries, jsonArgsOutputs, argsBlockInterval, jsonArgsCostPerBlock, argsEnabled, argsExtraInfo)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

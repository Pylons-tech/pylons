package cli

import (
	"encoding/json"
	github_com_cosmos_cosmos_sdk_types "github.com/cosmos/cosmos-sdk/types"
	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
)

func CmdCreateRecipe() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-recipe [index] [nodeVersion] [cookbookId] [name] [coinInput] [itemInput] [entries] [weightedOutputs] [description] [blockInterval] [enabled] [extraInfo]",
		Short: "Create a new Recipe",
		Args:  cobra.ExactArgs(12),
		RunE: func(cmd *cobra.Command, args []string) error {
			index := args[0]
			argsNodeVersion, err := cast.ToStringE(args[1])
			if err != nil {
				return err
			}
			argsCookbookId, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			argsName, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			argsCoinInput, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}
			jsonArgsCoinInput := github_com_cosmos_cosmos_sdk_types.Coins{}
			err = json.Unmarshal([]byte(argsCoinInput), &jsonArgsCoinInput)
			if err != nil {
				return err
			}
			argsItemInput, err := cast.ToStringE(args[5])
			if err != nil {
				return err
			}
			jsonArgsItemInput := make([]types.ItemInput, 0)
			err = json.Unmarshal([]byte(argsItemInput), &jsonArgsItemInput)
			if err != nil {
				return err
			}
			argsEntries, err := cast.ToStringE(args[6])
			if err != nil {
				return err
			}
			jsonArgsEntries := types.EntriesList{}
			err = json.Unmarshal([]byte(argsEntries), &jsonArgsEntries)
			if err != nil {
				return err
			}
			argsWeightedOutputs, err := cast.ToStringE(args[7])
			if err != nil {
				return err
			}
			jsonArgsWeightedOutputs := make([]types.WeightedOutputs, 0)
			err = json.Unmarshal([]byte(argsWeightedOutputs), &jsonArgsWeightedOutputs)
			if err != nil {
				return err
			}
			argsDescription, err := cast.ToStringE(args[8])
			if err != nil {
				return err
			}
			argsBlockInterval, err := cast.ToUint64E(args[9])
			if err != nil {
				return err
			}
			argsEnabled, err := cast.ToBoolE(args[10])
			if err != nil {
				return err
			}
			argsExtraInfo, err := cast.ToStringE(args[11])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateRecipe(clientCtx.GetFromAddress().String(), index, argsNodeVersion, argsCookbookId, argsName, jsonArgsCoinInput, jsonArgsItemInput, jsonArgsEntries, jsonArgsWeightedOutputs, argsDescription, argsBlockInterval, argsEnabled, argsExtraInfo)
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
		Use:   "update-recipe [index] [nodeVersion] [cookbookId] [name] [coinInput] [itemInput] [entries] [weightedOutputs] [description] [blockInterval] [enabled] [extraInfo]",
		Short: "Update a Recipe",
		Args:  cobra.ExactArgs(12),
		RunE: func(cmd *cobra.Command, args []string) error {
			index := args[0]

			argsNodeVersion, err := cast.ToStringE(args[1])
			if err != nil {
				return err
			}
			argsCookbookId, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			argsName, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			argsCoinInput, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}
			jsonArgsCoinInput := github_com_cosmos_cosmos_sdk_types.Coins{}
			err = json.Unmarshal([]byte(argsCoinInput), &jsonArgsCoinInput)
			if err != nil {
				return err
			}
			argsItemInput, err := cast.ToStringE(args[5])
			if err != nil {
				return err
			}
			jsonArgsItemInput := make([]types.ItemInput, 0)
			err = json.Unmarshal([]byte(argsItemInput), &jsonArgsItemInput)
			if err != nil {
				return err
			}
			argsEntries, err := cast.ToStringE(args[6])
			if err != nil {
				return err
			}
			jsonArgsEntries := types.EntriesList{}
			err = json.Unmarshal([]byte(argsEntries), &jsonArgsEntries)
			if err != nil {
				return err
			}
			argsWeightedOutputs, err := cast.ToStringE(args[7])
			if err != nil {
				return err
			}
			jsonArgsWeightedOutputs := make([]types.WeightedOutputs, 0)
			err = json.Unmarshal([]byte(argsWeightedOutputs), &jsonArgsWeightedOutputs)
			if err != nil {
				return err
			}
			argsDescription, err := cast.ToStringE(args[8])
			if err != nil {
				return err
			}
			argsBlockInterval, err := cast.ToUint64E(args[9])
			if err != nil {
				return err
			}
			argsEnabled, err := cast.ToBoolE(args[10])
			if err != nil {
				return err
			}
			argsExtraInfo, err := cast.ToStringE(args[11])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgUpdateRecipe(clientCtx.GetFromAddress().String(), index, argsNodeVersion, argsCookbookId, argsName, jsonArgsCoinInput, jsonArgsItemInput, jsonArgsEntries, jsonArgsWeightedOutputs, argsDescription, argsBlockInterval, argsEnabled, argsExtraInfo)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

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
		Long: `
The core of developing experiences on Pylons is the recipe. The structure of a recipe is complex and to have a more detailed
info on how to create recipes and having complete examples, please see https://github.com/Pylons-tech/pylons/blob/main/docs/RECIPE_WALKTHROUGH.md.

All the recipe fields are mandatory:

* "CookbookID" is the ID of the cookbook that contains this recipe.
* "RecipeID" is the unique identifier for this particular recipe.
* "Name" is the name of the recipe.
* "Description" is the plain text description of the recipe.
* "CoinInputs" detail which coins are required to run the recipe.
* "ItemInputs" detail which items are required to run the recipe.
* "Entries" is a list of the various outputs from the recipe. Items are established with an ID and a set of doubles, longs, and strings to refine the outputs.
* "Outputs" calls the unique IDs of the items in the entries list and uses the IDs as outputs after the execution of the recipe.
* "BlockInterval" indicates what block the recipe executes. For example, if blockInterval is at 2, the recipe executes after the chain has executed 2 blocks.
* "CostPerBlock" is a Cosmos SDK coin that is used to build the fee for paying for the execute-recipe transaction before the recipe blockInterval is met.
* "Enabled" is a boolean variable to enable the recipe.
`,
		Example: `
  pylonsd tx pylons create-recipe                                             \
  loud123456                                                                  \
  recipe_loud123456                                                           \
  "Legend of the Undead Dragon"                                               \
  "Cookbook for running pylons recreation of LOUD"                            \
  v0.3.1                                                                      \
  "[\"100000uatom\",\"10000000ubedrock\"]"                                    \
  "[]"                                                                        \
  "{}"                                                                        \
  "[]"                                                                        \
  1                                                                           \
  10000upylon                                                                 \
  true                                                                        \
  extra-info                                                                  \
  --from pylo1tqqp6wmctv0ykatyaefsqy6stj92lnt800lkee                          

`,
		Args: cobra.ExactArgs(13),
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

			var clientCtx client.Context

			if GetAltenativeContext() != nil {
				altCtx := GetAltenativeContext()
				if altCtx != nil {
					clientCtx = altCtx.WithSkipConfirmation(ForceSkipConfirm)
				} else {
					return err
				}
			} else {
				c, err := client.GetClientTxContext(cmd)
				if err != nil {
					return err
				}
				clientCtx = c
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
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

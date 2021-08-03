package cli

import (
	"encoding/json"
	"github.com/spf13/cobra"

	"github.com/spf13/cast"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdCreateItem() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create-item [index] [cookbookID] [nodeVersion] [doubles] [longs] [strings] [ownerRecipeID] [ownerTradeID] [tradeable] [lastUpdate] [transferFee]",
		Short: "Create a new Item",
		Args:  cobra.ExactArgs(11),
		RunE: func(cmd *cobra.Command, args []string) error {
			ID := args[0]
			argsCookbookID, err := cast.ToStringE(args[1])
			if err != nil {
				return err
			}
			argsNodeVersion, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			argsDoubles, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			jsonArgsDoubles := make([]types.DoubleKeyValue, 0)
			err = json.Unmarshal([]byte(argsDoubles), &jsonArgsDoubles)
			if err != nil {
				return err
			}
			argsLongs, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}
			jsonArgsLongs := make([]types.LongKeyValue, 0)
			err = json.Unmarshal([]byte(argsLongs), &jsonArgsLongs)
			if err != nil {
				return err
			}
			argsStrings, err := cast.ToStringE(args[5])
			if err != nil {
				return err
			}
			jsonArgsStrings := make([]types.StringKeyValue, 0)
			err = json.Unmarshal([]byte(argsStrings), &jsonArgsStrings)
			if err != nil {
				return nil
			}
			argsOwnerRecipeID, err := cast.ToStringE(args[6])
			if err != nil {
				return err
			}
			argsOwnerTradeID, err := cast.ToStringE(args[7])
			if err != nil {
				return err
			}
			argsTradeable, err := cast.ToBoolE(args[8])
			if err != nil {
				return err
			}
			argsLastUpdate, err := cast.ToUint64E(args[9])
			if err != nil {
				return err
			}
			argsTransferFee, err := cast.ToUint64E(args[10])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgCreateItem(clientCtx.GetFromAddress().String(), ID, argsCookbookID, argsNodeVersion, jsonArgsDoubles, jsonArgsLongs, jsonArgsStrings, argsOwnerRecipeID, argsOwnerTradeID, argsTradeable, argsLastUpdate, argsTransferFee)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

func CmdUpdateItem() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "update-item [index] [cookbookID] [nodeVersion] [doubles] [longs] [strings] [ownerRecipeID] [ownerTradeID] [tradeable] [lastUpdate] [transferFee]",
		Short: "Update a Item",
		Args:  cobra.ExactArgs(11),
		RunE: func(cmd *cobra.Command, args []string) error {
			ID := args[0]

			argsCookbookID, err := cast.ToStringE(args[1])
			if err != nil {
				return err
			}
			argsNodeVersion, err := cast.ToStringE(args[2])
			if err != nil {
				return err
			}
			argsDoubles, err := cast.ToStringE(args[3])
			if err != nil {
				return err
			}
			jsonArgsDoubles := make([]types.DoubleKeyValue, 0)
			err = json.Unmarshal([]byte(argsDoubles), &jsonArgsDoubles)
			if err != nil {
				return err
			}
			argsLongs, err := cast.ToStringE(args[4])
			if err != nil {
				return err
			}
			jsonArgsLongs := make([]types.LongKeyValue, 0)
			err = json.Unmarshal([]byte(argsLongs), &jsonArgsLongs)
			if err != nil {
				return err
			}
			argsStrings, err := cast.ToStringE(args[5])
			if err != nil {
				return err
			}
			jsonArgsStrings := make([]types.StringKeyValue, 0)
			err = json.Unmarshal([]byte(argsStrings), &jsonArgsStrings)
			if err != nil {
				return nil
			}
			argsOwnerRecipeID, err := cast.ToStringE(args[6])
			if err != nil {
				return err
			}
			argsOwnerTradeID, err := cast.ToStringE(args[7])
			if err != nil {
				return err
			}
			argsTradeable, err := cast.ToBoolE(args[8])
			if err != nil {
				return err
			}
			argsLastUpdate, err := cast.ToUint64E(args[9])
			if err != nil {
				return err
			}
			argsTransferFee, err := cast.ToUint64E(args[10])
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgUpdateItem(clientCtx.GetFromAddress().String(), ID, argsCookbookID, argsNodeVersion, jsonArgsDoubles, jsonArgsLongs, jsonArgsStrings, argsOwnerRecipeID, argsOwnerTradeID, argsTradeable, argsLastUpdate, argsTransferFee)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

// TODO remove
func CmdDeleteItem() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "delete-item [index]",
		Short: "Delete a Item",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			index := args[0]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgDeleteItem(clientCtx.GetFromAddress().String(), index)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}

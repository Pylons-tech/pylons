package cmd

import (
	"encoding/json"
	"strconv"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
)

func DevCreate() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create [account] [path]",
		Short: "Creates and executes creation transactions for Pylons recipe or cookbook files in the provided path, using credentials of provided account",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			accountName := args[0]
			path := args[1]
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}
			k, err := clientCtx.Keyring.Key(accountName)
			if err != nil {
				return err
			}
			addr, err := k.GetAddress()
			if err != nil {
				return err
			}
			cli.SetAlternativeContext(clientCtx.WithFromAddress(addr).WithFromName(accountName).WithBroadcastMode("block"))
			ForFiles(path, func(path string, cb types.Cookbook) {
				c := cli.CmdCreateCookbook()
				c.SetArgs([]string{cb.Id, cb.Name, cb.Description, cb.Developer, cb.Version, cb.SupportEmail, strconv.FormatBool(cb.Enabled)})
				err := c.Execute()
				if err != nil {
					panic(err)
				}
			}, func(path string, rcp types.Recipe) {
				c := cli.CmdCreateRecipe()
				coinInputJSON, err := json.Marshal(rcp.CoinInputs)
				if err != nil {
					panic(err)
				}

				itemInputJSON, err := json.Marshal(rcp.ItemInputs)
				if err != nil {
					panic(err)
				}

				entryJSON, err := json.Marshal(rcp.Entries)
				if err != nil {
					panic(err)
				}

				outputJSON, err := json.Marshal(rcp.Outputs)
				if err != nil {
					panic(err)
				}
				c.SetArgs([]string{
					rcp.CookbookId, rcp.Id, rcp.Name, rcp.Description, rcp.Version,
					string(coinInputJSON), string(itemInputJSON), string(entryJSON), string(outputJSON), strconv.FormatInt(rcp.BlockInterval, 10),
					rcp.CostPerBlock.String(), strconv.FormatBool(rcp.Enabled), rcp.ExtraInfo,
				})
				err = c.Execute()
				if err != nil {
					panic(err)
				}
			})
			return nil
		},
	}
	return cmd
}

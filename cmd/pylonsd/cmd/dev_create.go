package cmd

import (
	"strconv"

	"github.com/spf13/cobra"
	"github.com/tendermint/tendermint/libs/json"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func DevCreate() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create [account] [path]",
		Short: "Creates and executes creation transactions Pylons recipe or cookbook files in the provided path, using credentials of provided account",
		Args:  cobra.ExactArgs(2),
		Run: func(cmd *cobra.Command, args []string) {
			accountName := args[0]
			path := args[1]
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				panic(err)
			}
			ks, err := clientCtx.Keyring.List()
			if err != nil {
				panic(err)
			}

			var addr sdk.AccAddress
			// This is slower than Keyring.Key, but we need to not break on in-memory keyrings
			for _, k := range ks {
				if k.GetName() == accountName {
					addr = k.GetAddress()
					break
				}
			}
			cli.SetAlternativeContext(clientCtx.WithFromAddress(addr))
			ForFiles(path, func(path string, cb types.Cookbook) {
				c := cli.CmdCreateCookbook()
				c.SetArgs([]string{cb.Id, cb.Name, cb.Description, cb.Developer, cb.Version, cb.SupportEmail, strconv.FormatBool(cb.Enabled)})
				var err error
				err = c.Flags().Set(flags.FlagSkipConfirmation, "true")
				if err != nil {
					panic(err)
				}
				err = c.Flags().Set(flags.FlagBroadcastMode, flags.BroadcastBlock)
				if err != nil {
					panic(err)
				}
				err = c.Flags().Set("from", accountName)
				if err != nil {
					panic(err)
				}
				err = c.Execute()
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

				outputJSON, err := json.Marshal(rcp.Outputs)
				if err != nil {
					panic(err)
				}

				c.SetArgs([]string{
					rcp.CookbookId, rcp.Id, rcp.Name, rcp.Description, rcp.Version,
					string(coinInputJSON), string(itemInputJSON), rcp.Entries.String(), string(outputJSON), strconv.FormatInt(rcp.BlockInterval, 10),
					rcp.CostPerBlock.String(), rcp.ExtraInfo,
				})
				err = c.Flags().Set("from", accountName)
				if err != nil {
					panic(err)
				}
				err = c.Execute()
				if err != nil {
					panic(err)
				}
			})
		},
	}
	return cmd
}

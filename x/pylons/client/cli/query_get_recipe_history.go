package cli

import (
	"strconv"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdGetRecipeHistory() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-recipe-history [cookbook-id] [recipe-id]",
		Short: "Query GetRecipeHistory",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) (err error) {
			reqCookbookID := args[0]
			reqRecipeID := args[1]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryGetRecipeHistoryRequest{
				CookbookID: reqCookbookID,
				RecipeID:   reqRecipeID,
			}

			res, err := queryClient.GetRecipeHistory(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

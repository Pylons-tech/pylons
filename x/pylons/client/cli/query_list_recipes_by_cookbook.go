package cli

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
)

var _ = strconv.Itoa(0)

func CmdListRecipesByCookbook() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-recipes-by-cookbook [id]",
		Short: "list recipes by cookbook ID",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			reqCookbookID := args[0]

			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryListRecipesByCookbookRequest{
				CookbookId: reqCookbookID,
			}

			res, err := queryClient.ListRecipesByCookbook(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

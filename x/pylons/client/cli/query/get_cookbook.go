package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"
)

// GetCookbook get cookbook by GUID
func GetCookbook() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get_cookbook <id>",
		Short: "get a cookbook by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientQueryContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			cookbookReq := &types.GetCookbookRequest{
				CookbookID: args[0],
			}

			res, err := queryClient.GetCookbook(cmd.Context(), cookbookReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}

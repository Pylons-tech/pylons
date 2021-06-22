package query

import (
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// ListCookbook queries the cookbooks
func ListCookbook() *cobra.Command {
	var accAddr string
	cmd := &cobra.Command{
		Use:   "list_cookbook",
		Short: "get all cookbooks for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			cookbookReq := &types.ListCookbookRequest{
				Address: accAddr,
			}

			res, err := queryClient.ListCookbook(cmd.Context(), cookbookReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	cmd.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}

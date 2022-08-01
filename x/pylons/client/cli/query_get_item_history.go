package cli

import (
	"strconv"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdGetItemHistory() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-item-history [cookbook-id] [item-id]",
		Short: "Get Item Ownership History",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) (err error) {
			reqCookbookID := args[0]
			reqItemID := args[1]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryGetItemHistoryRequest{
				CookbookId: reqCookbookID,
				ItemId:     reqItemID,
			}

			res, err := queryClient.GetItemOwnershipHistory(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

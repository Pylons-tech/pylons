package cli

import (
	"strconv"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdListExecutionsByItem() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-executions-by-item [cookbook-id] [id]",
		Short: "list all executions where item is input and/or output",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			reqCookbookID := args[0]
			reqItemID := args[1]

			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryListExecutionsByItemRequest{
				CookbookID: reqCookbookID,
				ItemID:     reqItemID,
			}

			res, err := queryClient.ListExecutionsByItem(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

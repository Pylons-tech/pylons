package cli

import (
	"strconv"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdListItemByOwner() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-item-by-owner [owner]",
		Short: "List items by owner",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			reqOwner := args[0]

			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryListItemByOwnerRequest{
				Owner: reqOwner,
			}

			res, err := queryClient.ListItemByOwner(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

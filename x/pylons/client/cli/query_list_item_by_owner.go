package cli

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
)

var _ = strconv.Itoa(0)

func CmdListItemByOwner() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-item-by-owner [address]",
		Short: "list items by owner address",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			reqOwner := args[0]

			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryListItemByOwnerRequest{
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

package cli

import (
	"github.com/spf13/cobra"
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
)

var _ = strconv.Itoa(0)

func CmdListCookbookByCreator() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-cookbook-by-creator [creator]",
		Short: "List cookbooks by creator",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			reqCreator := string(args[0])

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryListCookbookByCreatorRequest{

				Creator: reqCreator,
			}

			res, err := queryClient.ListCookbookByCreator(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

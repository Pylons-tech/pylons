package cli

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
)

var _ = strconv.Itoa(0)

func CmdListCookbooksByCreator() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-cookbooks [address]",
		Short: "list cookbooks by owner address",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) (err error) {
			reqCreator := args[0]

			// verify address is proper
			_, err = sdk.AccAddressFromBech32(reqCreator)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryListCookbooksByCreatorRequest{
				Creator: reqCreator,
			}

			res, err := queryClient.ListCookbooksByCreator(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

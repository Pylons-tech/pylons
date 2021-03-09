package query

import (
	"fmt"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

// GetCookbook get cookbook by GUID
func GetCookbook() *cobra.Command {
	ccb := &cobra.Command{
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

			return clientCtx.PrintString(fmt.Sprintf(
				"NodeVersion: %s \nID: %s \nName: %s \nDescription: %s  \nVersion: %s \nDeveloper: %s \nLevel: %d \nSupportEmail: %s \nCostPerBlock: %d \nSender: %s",
				res.NodeVersion.String(),
				res.ID,
				res.Name,
				res.Description,
				res.Version.GetNumber(),
				res.Developer,
				res.Level.GetNumber(),
				res.SupportEmail.GetStr(),
				res.CostPerBlock,
				res.Sender,
			))
		},
	}
	return ccb
}

package query

import (
	"errors"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetPylonsBalance queries the pylons balance
func GetPylonsBalance() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "balance [name]",
		Short: "get pylons balance",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientQueryContext(cmd)
			if err != nil {
				return err
			}

			keys, err := keyring.New(sdk.KeyringServiceName(), keyring.BackendTest, clientCtx.KeyringDir, clientCtx.Input)
			if err != nil {
				return errors.New("cannot get the keys from home")
			}

			infos, err := keys.List()
			if err != nil {
				return errors.New(err.Error())
			}

			for _, info := range infos {
				if info.GetName() == args[0] {
					queryClient := types.NewQueryClient(clientCtx)

					balanceReq := &types.PylonsBalanceRequest{
						Address: info.GetAddress().String(),
					}

					res, err := queryClient.PylonsBalance(cmd.Context(), balanceReq)
					if err != nil {
						return err
					}

					return clientCtx.PrintString(res.String())
				}
			}
			return errors.New("cannot get the balance using this name")
		},
	}

	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}

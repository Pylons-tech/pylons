package tx

import (
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// CreateAccount implements CreateAccount msg transaction
func CreateAccount() *cobra.Command {
	ccb := &cobra.Command{
		Use:   "create-account",
		Short: "register an account on chain.",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			addr := clientCtx.GetFromAddress()

			createTx := &msgs.MsgCreateAccount{
				Requester: addr.String(),
			}

			err = createTx.ValidateBasic()
			if err != nil {
				return err
			}

			txf := tx.NewFactoryCLI(clientCtx, cmd.Flags())
			return GenerateOrBroadcastMsgs(clientCtx, txf, []sdk.Msg{createTx}...)

		},
	}
	return ccb
}

package tx

import (
	"bufio"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"

	"github.com/spf13/cobra"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SendCoins implements sending pylons and game coisn
func SendCoins() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "send [to_address] [amount]",
		Short: "send pylons and game coins to the address provided",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			inBuf := bufio.NewReader(cmd.InOrStdin())
			keys, err := keyring.New(sdk.KeyringServiceName(), keyring.BackendTest, clientCtx.KeyringDir, inBuf)
			if err != nil {
				return errors.New("cannot get the keys from home")
			}

			var addr sdk.AccAddress
			addr, err = sdk.AccAddressFromBech32(args[0])
			// if its not an address
			if err != nil {
				info, err := keys.Key(args[0])
				if err != nil {
					return errors.New(err.Error())
				}
				addr = info.GetAddress()
			}

			coins, err := sdk.ParseCoinsNormalized(args[1])
			if err != nil {
				return err
			}
			msg := &types.MsgSendCoins{
				Amount:   coins,
				Sender:   clientCtx.GetFromAddress().String(),
				Receiver: addr.String(),
			}
			err = msg.ValidateBasic()
			if err != nil {
				return err
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{msg}...)
		},
	}

	flags.AddTxFlagsToCmd(cmd)
	return cmd
}

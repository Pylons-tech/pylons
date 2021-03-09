package tx

import (
	"bufio"
	"errors"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"

	"github.com/spf13/cobra"
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/tx"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SendPylons implements SendPylons msg transaction
func SendPylons() *cobra.Command {
	ccb := &cobra.Command{
		Use:   "send-pylons [name] [amount]",
		Short: "send pylons of specific amount to the name provided",
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

			amount, err := strconv.Atoi(args[1])
			if err != nil {
				return err
			}
			msg := msgs.NewMsgSendCoins(types.NewPylon(int64(amount)), clientCtx.GetFromAddress(), addr)
			err = msg.ValidateBasic()
			if err != nil {
				return err
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{&msg}...)
		},
	}
	return ccb
}

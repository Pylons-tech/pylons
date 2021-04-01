package tx

import (
	"bufio"
	"errors"
	"fmt"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/spf13/cobra"
)

// SendItems implements SendItems msg transaction
func SendItems(queryRoute string) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "send-items [address] [item_ids]",
		Short: "send items to the address provided",
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

			itemIDsArray := strings.Split(args[1], ",")

			msg := msgs.NewMsgSendItems(itemIDsArray, clientCtx.GetFromAddress().String(), addr.String())
			err = msg.ValidateBasic()
			if err != nil {
				return err
			}

			for _, val := range itemIDsArray {
				res, _, err := clientCtx.QueryWithData(fmt.Sprintf("custom/%s/get_item/%s", queryRoute, val), nil)
				if err != nil {
					return err
				}

				var targetItem *types.Item
				if err := targetItem.Unmarshal(res); err != nil {
					return err
				}

				if targetItem.GetSender() != msg.GetSender() {
					return errors.New("Item is not the sender's one")
				}

				if err = targetItem.NewTradeError(); err != nil {
					return err
				}
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{&msg}...)
		},
	}

	flags.AddTxFlagsToCmd(cmd)
	return cmd
}

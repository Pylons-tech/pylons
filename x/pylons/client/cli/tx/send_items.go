package tx

import (
	"bufio"
	"errors"
	"fmt"
	"strings"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/keys"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SendItems implements SendItems msg transaction
func SendItems(queryRoute string, cdc *codec.Codec) *cobra.Command {
	ccb := &cobra.Command{
		Use:   "send-items [address] [item_id]",
		Short: "send items to the address provided",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			inBuf := bufio.NewReader(cmd.InOrStdin())
			txBldr := auth.NewTxBuilderFromCLI(inBuf).WithTxEncoder(utils.GetTxEncoder(cdc))

			kb, err := keys.NewKeyBaseFromDir(viper.GetString(flags.FlagHome))
			if err != nil {
				return errors.New("cannot get the keys from home")
			}

			// return cliCtx.PrintOutput(out)

			var addr sdk.AccAddress
			addr, err = sdk.AccAddressFromBech32(args[0])
			// if its not an address
			if err != nil {
				info, err := kb.Get(args[0])
				if err != nil {
					return err
				}
				addr = info.GetAddress()
			}

			msg := msgs.NewMsgSendItems(args[1], cliCtx.GetFromAddress(), addr)
			err = msg.ValidateBasic()
			if err != nil {
				return err
			}

			itemIDsArray := strings.Split(args[1], ",")

			for _, val := range itemIDsArray {

				res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/get_item/%s", queryRoute, val), nil)
				if err != nil {
					return fmt.Errorf(err.Error())
				}

				var targetItem types.Item
				cdc.MustUnmarshalJSON(res, &targetItem)

				if targetItem.Sender.String() != msg.Sender.String() {
					return errors.New("Item is not the Sender's one")
				}
			}

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msg})
		},
	}
	return ccb
}

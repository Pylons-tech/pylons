package tx

import (
	"bufio"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// FiatItem is the client cli command for creating item
func FiatItem(cdc *codec.Codec) *cobra.Command {
	var msgFI msgs.MsgFiatItem

	ccb := &cobra.Command{
		Use:   "fiat-item [args]",
		Short: "create item and assign it to sender",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)
			inBuf := bufio.NewReader(cmd.InOrStdin())
			txBldr := auth.NewTxBuilderFromCLI(inBuf).WithTxEncoder(utils.GetTxEncoder(cdc))

			byteValue, err := ReadFile(args[0])
			if err != nil {
				return err
			}
			err = cdc.UnmarshalJSON(byteValue, &msgFI)
			if err != nil {
				return err
			}
			msgFI.Sender = cliCtx.GetFromAddress()

			err = msgFI.ValidateBasic()
			if err != nil {
				return err
			}

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msgFI})
		},
	}

	ccb.PersistentFlags().StringVar(&msgFI.CookbookID, "cookbookID", "", "The ID of the cookbook for this item")

	ccb.PersistentFlags().String(FlagKeyringBackend, "os", "Select keyring's backend (os|file|test)")
	ccb.PersistentFlags().String(FlagFrom, "", "Name or address of private key with which to sign")
	ccb.PersistentFlags().String(FlagBroadcastMode, BroadcastSync, "Transaction broadcasting mode (sync|async|block)")

	return ccb
}

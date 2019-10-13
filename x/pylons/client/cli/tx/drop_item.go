package tx

import (
	"github.com/spf13/cobra"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/utils"
	"github.com/cosmos/cosmos-sdk/codec"

	sdk "github.com/cosmos/cosmos-sdk/types"
	authtxb "github.com/cosmos/cosmos-sdk/x/auth/client/txbuilder"
)

// DropItem is the client cli command for dropping item
func DropItem(cdc *codec.Codec) *cobra.Command {

	var msgDI msgs.MsgDropItem

	ccb := &cobra.Command{
		Use:   "drop-item [args]",
		Short: "drop item by providing the args",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc).WithAccountDecoder(cdc)

			txBldr := authtxb.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc))

			if err := cliCtx.EnsureAccountExists(); err != nil {
				return err
			}

			// TODO: DropItem params should set from CLI args

			err := msgDI.ValidateBasic()
			if err != nil {
				return err
			}

			cliCtx.PrintResponse = true

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msgDI}, false)
		},
	}

	ccb.PersistentFlags().StringVar(&msgDI.CookbookID, "cookbookID", "", "The name of the cookbook for this item")

	return ccb
}

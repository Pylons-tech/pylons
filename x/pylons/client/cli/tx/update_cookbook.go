package tx

import (
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// UpdateCookbook is the client cli command for creating cookbook
func UpdateCookbook(cdc *codec.Codec) *cobra.Command {

	var msgCCB msgs.MsgUpdateCookbook
	var tmpVersion string
	var tmpEmail string

	ccb := &cobra.Command{
		Use:   "update-cookbook [args]",
		Short: "update cookbook by providing the args",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc).WithAccountDecoder(cdc)

			txBldr := auth.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc))

			if err := cliCtx.EnsureAccountExists(); err != nil {
				return err
			}
			msgCCB.Sender = cliCtx.GetFromAddress()
			msgCCB.Version = types.SemVer(tmpVersion)
			msgCCB.SupportEmail = types.Email(tmpEmail)

			err := msgCCB.ValidateBasic()
			if err != nil {
				return err
			}

			cliCtx.PrintResponse = true

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msgCCB}, false)
		},
	}

	ccb.PersistentFlags().StringVar(&msgCCB.Description, "desc", "", "The description for the cookbook")
	ccb.PersistentFlags().StringVar(&msgCCB.Developer, "developer", "", "The developer of the cookbook")
	ccb.PersistentFlags().StringVar(&tmpEmail, "email", "", "The support email")
	ccb.PersistentFlags().StringVar(&tmpVersion, "version", "", "The version of the cookbook")

	return ccb
}

package tx

import (
	// "strconv"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	// "github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/utils"
	"github.com/cosmos/cosmos-sdk/codec"

	sdk "github.com/cosmos/cosmos-sdk/types"
	authtxb "github.com/cosmos/cosmos-sdk/x/auth/client/txbuilder"
)

// CreateCookbook is the client cli command for creating cookbook
func CreateCookbook(cdc *codec.Codec) *cobra.Command {

	var msgCCB msgs.MsgCreateCookbook
	// var tmpVersion string
	// var tmpEmail string
	// var tmpLevel string

	ccb := &cobra.Command{
		Use:   "create-cookbook [args]",
		Short: "create cookbook by providing the args",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			// This command is automatically setting the sender with --from address
			// If we set level, version, support_email, tmp_level name and description separately, 
			// it can be very complex, especially for other commands like create_recipe, fiat_item

			cliCtx := context.NewCLIContext().WithCodec(cdc).WithAccountDecoder(cdc)

			txBldr := authtxb.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc))

			if err := cliCtx.EnsureAccountExists(); err != nil {
				return err
			}
			// lvl, err := strconv.Atoi(tmpLevel)
			// if err != nil {
			// 	return err
			// }
			byteValue, err := ReadFile(args[0])
			if err != nil {
				return err
			}
			err = cdc.UnmarshalJSON(byteValue, &msgCCB)
			if err != nil {
				return err
			}
			
			// msgCCB.Level = types.Level(lvl)
			// msgCCB.Version = types.SemVer(tmpVersion)
			// msgCCB.SupportEmail = types.Email(tmpEmail)
			msgCCB.Sender = cliCtx.GetFromAddress()

			err = msgCCB.ValidateBasic()
			if err != nil {
				return err
			}

			cliCtx.PrintResponse = true

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msgCCB}, false)
		},
	}

	// Keeping it as commented, in case we need this later
	// ccb.PersistentFlags().StringVar(&msgCCB.Name, "name", "", "The name of the cookbook")
	// ccb.PersistentFlags().StringVar(&msgCCB.Description, "desc", "", "The description for the cookbook")
	// ccb.PersistentFlags().StringVar(&msgCCB.Developer, "developer", "", "The developer of the cookbook")
	// ccb.PersistentFlags().StringVar(&tmpEmail, "email", "", "The support email")
	// ccb.PersistentFlags().StringVar(&tmpVersion, "version", "", "The version of the cookbook")
	// ccb.PersistentFlags().StringVar(&tmpLevel, "level", "", "The level of the cookbook")

	return ccb
}

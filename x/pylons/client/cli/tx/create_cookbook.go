package tx

import (
	// "strconv"

	"bufio"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	// "github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// CreateCookbook is the client cli command for creating cookbook
func CreateCookbook(cdc *codec.Codec) *cobra.Command {

	var msgCCB msgs.MsgCreateCookbook

	ccb := &cobra.Command{
		Use:   "create-cookbook [args]",
		Short: "create cookbook by providing the args",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			// This command is automatically setting the sender with --from address
			// If we set level, version, support_email, tmp_level name and description separately,
			// it can be very complex, especially for other commands like create_recipe, fiat_item

			cliCtx := context.NewCLIContext().WithCodec(cdc)
			inBuf := bufio.NewReader(cmd.InOrStdin())
			txBldr := auth.NewTxBuilderFromCLI(inBuf).WithTxEncoder(utils.GetTxEncoder(cdc))

			byteValue, err := ReadFile(args[0])
			if err != nil {
				return err
			}
			err = cdc.UnmarshalJSON(byteValue, &msgCCB)
			if err != nil {
				return err
			}

			msgCCB.Sender = cliCtx.GetFromAddress()

			err = msgCCB.ValidateBasic()
			if err != nil {
				return err
			}

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msgCCB})
		},
	}

	return ccb
}

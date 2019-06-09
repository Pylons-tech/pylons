package tx

import (
	"errors"

	"github.com/spf13/cobra"

	"strconv"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/keys"
	"github.com/cosmos/cosmos-sdk/client/utils"
	"github.com/cosmos/cosmos-sdk/codec"

	sdk "github.com/cosmos/cosmos-sdk/types"
	authtxb "github.com/cosmos/cosmos-sdk/x/auth/client/txbuilder"
)

func SendPylons(cdc *codec.Codec) *cobra.Command {
	return &cobra.Command{
		Use:   "send-pylons [name] [amount]",
		Short: "send pylons of specific amount to the name provided",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc).WithAccountDecoder(cdc)

			txBldr := authtxb.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc))

			if err := cliCtx.EnsureAccountExists(); err != nil {
				return err
			}

			kb, err := keys.NewKeyBaseFromHomeFlag()
			if err != nil {
				return errors.New("cannot get the keys from home")
			}

			info, err := kb.Get(args[0])
			if err != nil {
				return err
			}

			amount, err := strconv.Atoi(args[1])
			if err != nil {
				return err
			}
			msg := msgs.NewMsgSendPylons(types.NewPylon(int64(amount)), cliCtx.GetFromAddress(), info.GetAddress())
			err = msg.ValidateBasic()
			if err != nil {
				return err
			}

			cliCtx.PrintResponse = true

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msg}, false)
		},
	}
}

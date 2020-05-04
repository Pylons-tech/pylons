package tx

import (
	"bufio"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

const (
	// BroadcastBlock defines a tx broadcasting mode where the client waits for
	// the tx to be committed in a block.
	BroadcastBlock = "block"
	// BroadcastSync defines a tx broadcasting mode where the client waits for
	// a CheckTx execution response only.
	BroadcastSync = "sync"
	// BroadcastAsync defines a tx broadcasting mode where the client returns
	// immediately.
	BroadcastAsync = "async"

	FlagFrom               = "from"
	FlagBroadcastMode      = "broadcast-mode"
	FlagKeyringBackend     = "keyring-backend"
)

const (
	// DefaultCoinPerRequest is the number of coins that will be sent per faucet request
	DefaultCoinPerRequest = 500
)

func GetPylons(cdc *codec.Codec) *cobra.Command {
	ccb := &cobra.Command{
		Use:   "get-pylons",
		Short: "ask for pylons. 500 pylons per request",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)
			inBuf := bufio.NewReader(cmd.InOrStdin())
			txBldr := auth.NewTxBuilderFromCLI(inBuf).WithTxEncoder(utils.GetTxEncoder(cdc))

			msg := msgs.NewMsgGetPylons(types.NewPylon(DefaultCoinPerRequest), cliCtx.GetFromAddress())
			err := msg.ValidateBasic()
			if err != nil {
				return err
			}

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msg})
		},
	}
	ccb.PersistentFlags().String(FlagKeyringBackend, "os", "Select keyring's backend (os|file|test)")
	ccb.PersistentFlags().String(FlagFrom, "", "Name or address of private key with which to sign")
	ccb.PersistentFlags().String(FlagBroadcastMode, BroadcastSync, "Transaction broadcasting mode (sync|async|block)")
	return ccb
}

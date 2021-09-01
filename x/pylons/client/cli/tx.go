package cli

import (
	"fmt"
	"time"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	// "github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var (
	DefaultRelativePacketTimeoutTimestamp = uint64((time.Duration(10) * time.Minute).Nanoseconds())
)

const (
	// nolint: deadcode, unused
	flagPacketTimeoutTimestamp = "packet-timeout-timestamp"
)

// GetTxCmd returns the transaction commands for this module
func GetTxCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:                        types.ModuleName,
		Short:                      fmt.Sprintf("%s transactions subcommands", types.ModuleName),
		DisableFlagParsing:         true,
		SuggestionsMinimumDistance: 2,
		RunE:                       client.ValidateCmd,
	}

	// this line is used by starport scaffolding # 1
	cmd.AddCommand(CmdFulfillTrade())

	cmd.AddCommand(CmdCreateTrade())
	cmd.AddCommand(CmdUpdateTrade())
	cmd.AddCommand(CmdDeleteTrade())

	cmd.AddCommand(CmdCompleteExecutionEarly())

	cmd.AddCommand(CmdTransferCookbook())

	cmd.AddCommand(CmdGoogleInAppPurchaseGetPylons())

	cmd.AddCommand(CmdCreateAccount())

	cmd.AddCommand(CmdSendItems())

	cmd.AddCommand(CmdExecuteRecipe())

	cmd.AddCommand(CmdSetItemString())

	cmd.AddCommand(CmdCreateRecipe())
	cmd.AddCommand(CmdUpdateRecipe())

	cmd.AddCommand(CmdCreateCookbook())
	cmd.AddCommand(CmdUpdateCookbook())

	return cmd
}

package cli

import (
	"fmt"
	// "strings"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	// "github.com/cosmos/cosmos-sdk/client/flags"
	// sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetQueryCmd returns the cli query commands for this module
func GetQueryCmd(queryRoute string) *cobra.Command {
	// Group pylons queries under a subcommand
	cmd := &cobra.Command{
		Use:                        types.ModuleName,
		Short:                      fmt.Sprintf("Querying commands for the %s module", types.ModuleName),
		DisableFlagParsing:         true,
		SuggestionsMinimumDistance: 2,
		RunE:                       client.ValidateCmd,
	}

	cmd.AddCommand(CmdListTradesByCreator())

	cmd.AddCommand(CmdGetRecipeHistory())

	// this line is used by starport scaffolding # 1

	cmd.AddCommand(CmdListRedeemInfo())
	cmd.AddCommand(CmdShowRedeemInfo())

	cmd.AddCommand(CmdListPaymentInfo())
	cmd.AddCommand(CmdShowPaymentInfo())

	cmd.AddCommand(CmdGetUsernameByAddress())

	cmd.AddCommand(CmdGetAddressByUsername())

	cmd.AddCommand(CmdShowTrade())

	cmd.AddCommand(CmdListItemByOwner())

	cmd.AddCommand(CmdShowGoogleIAPOrder())

	cmd.AddCommand(CmdListExecutionsByItem())

	cmd.AddCommand(CmdListExecutionsByRecipe())

	cmd.AddCommand(CmdShowExecution())

	cmd.AddCommand(CmdListRecipesByCookbook())

	cmd.AddCommand(CmdShowItem())

	cmd.AddCommand(CmdShowRecipe())

	cmd.AddCommand(CmdListCookbooksByCreator())
	cmd.AddCommand(CmdShowCookbook())

	return cmd
}

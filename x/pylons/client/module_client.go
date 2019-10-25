package client

import (
	"github.com/MikeSofaer/pylons/x/pylons/client/cli/query"
	"github.com/MikeSofaer/pylons/x/pylons/client/cli/tx"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
	amino "github.com/tendermint/go-amino"
)

// ModuleClient exports all client functionality from this module
type ModuleClient struct {
	storeKey string
	cdc      *amino.Codec
}

// NewModuleClient returns a new module client which holds both tx and query kind of handlers
func NewModuleClient(storeKey string, cdc *amino.Codec) ModuleClient {
	return ModuleClient{storeKey, cdc}
}

// GetTxCmd returns the transaction commands for this module
func (mc ModuleClient) GetTxCmd() *cobra.Command {
	pylonsTxCmd := &cobra.Command{
		Use:   "pylons",
		Short: "Pylons transactions subcommands",
	}

	pylonsTxCmd.AddCommand(client.PostCommands(
		tx.GetPylons(mc.cdc),
		tx.SendPylons(mc.cdc),
		tx.CreateCookbook(mc.cdc),
		tx.UpdateCookbook(mc.cdc),
	)...)

	return pylonsTxCmd
}

// GetQueryCmd returns the cli query commands for this module
func (mc ModuleClient) GetQueryCmd() *cobra.Command {
	// Group pulons queries under a subcommand
	pylonsQueryCmd := &cobra.Command{
		Use:   "pylons",
		Short: "Querying commands for the pylons module",
	}
	pylonsQueryCmd.AddCommand(client.GetCommands(
		query.GetPylonsBalance(mc.storeKey, mc.cdc),
		query.GetCookbook(mc.storeKey, mc.cdc),
		query.GetExecution(mc.storeKey, mc.cdc),
		query.GetItem(mc.storeKey, mc.cdc),
		query.GetRecipe(mc.storeKey, mc.cdc),
		query.ListCookbook(mc.storeKey, mc.cdc),
		query.ListRecipes(mc.storeKey, mc.cdc),
		query.ItemsBySender(mc.storeKey, mc.cdc),
		query.ListExecutions(mc.storeKey, mc.cdc),
	)...)

	return pylonsQueryCmd
}

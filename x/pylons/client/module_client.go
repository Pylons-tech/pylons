package client

import (
	plncli "github.com/MikeSofaer/pylons/x/pylons/client/cli"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
	amino "github.com/tendermint/go-amino"
)

// ModuleClient exports all client functionality from this module
type ModuleClient struct {
	storeKey string
	cdc      *amino.Codec
}

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
		plncli.GetPylons(mc.cdc),
		plncli.SendPylons(mc.cdc),
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
		plncli.GetPylonsBalance(mc.storeKey, mc.cdc),
	)...)

	return pylonsQueryCmd
}

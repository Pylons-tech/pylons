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
	namesvcTxCmd := &cobra.Command{
		Use:   "pylons",
		Short: "Pylons transactions subcommands",
	}

	namesvcTxCmd.AddCommand(client.PostCommands(
		plncli.GetPylons(mc.cdc),
	)...)

	return namesvcTxCmd
}

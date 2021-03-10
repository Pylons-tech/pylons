package main

import (
	"github.com/cosmos/cosmos-sdk/simapp"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
	"os"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/cmd/pylonsd/cmd"
	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"
)

func main() {
	rootCmd, _ := cmd.NewRootCmd()
	rootCmd.AddCommand(testnetCmd(simapp.ModuleBasics, banktypes.GenesisBalancesIterator{}))

	if err := svrcmd.Execute(rootCmd, app.DefaultNodeHome); err != nil {
		os.Exit(1)
	}
}

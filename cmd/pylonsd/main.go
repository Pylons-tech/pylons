package main

import (
	app "github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/app/params"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/debug"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/server"
	servertypes "github.com/cosmos/cosmos-sdk/server/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth/types"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
	"github.com/cosmos/cosmos-sdk/x/crisis"
	genutilcli "github.com/cosmos/cosmos-sdk/x/genutil/client/cli"
	"github.com/spf13/cobra"
	"github.com/tendermint/tendermint/libs/cli"
	"github.com/tendermint/tendermint/libs/log"
	dbm "github.com/tendermint/tm-db"
	"io"
	"os"
)

// DefaultNodeHome sets the folder where the application data and configuration will be stored
var DefaultNodeHome = os.ExpandEnv("$HOME/.pylonsd")

const (
	flagClientHome = "home-client"
)

func main() {
	cobra.EnableCommandSorting = false

	cdc := params.MakeCodec()
	config := sdk.GetConfig()
	config.SetBech32PrefixForAccount(sdk.Bech32PrefixAccAddr, sdk.Bech32PrefixAccPub)
	config.SetBech32PrefixForValidator(sdk.Bech32PrefixValAddr, sdk.Bech32PrefixValPub)
	config.SetBech32PrefixForConsensusNode(sdk.Bech32PrefixConsAddr, sdk.Bech32PrefixConsPub)
	config.Seal()
	ctx := server.NewDefaultContext()

	encodingConfig := params.MakeEncodingConfig()

	initClientCtx := client.Context{}.
		WithJSONMarshaler(encodingConfig.Marshaler).
		WithInterfaceRegistry(encodingConfig.InterfaceRegistry).
		WithTxConfig(encodingConfig.TxConfig).
		WithLegacyAmino(encodingConfig.Amino).
		WithInput(os.Stdin).
		WithAccountRetriever(types.AccountRetriever{}).
		WithBroadcastMode(flags.BroadcastBlock).
		WithHomeDir(app.DefaultNodeHome)

	rootCmd := &cobra.Command{
		Use:   "pylonsd",
		Short: "pylons App Daemon (server)",
		PersistentPreRunE: func(cmd *cobra.Command, _ []string) error {
			if err := client.SetCmdClientContextHandler(initClientCtx, cmd); err != nil {
				return err
			}

			return server.InterceptConfigsPreRunHandler(cmd)
		},
	}

	rootCmd.AddCommand(genutilcli.InitCmd(app.ModuleBasics, app.DefaultNodeHome))
	rootCmd.AddCommand(genutilcli.CollectGenTxsCmd(banktypes.GenesisBalancesIterator{}, app.DefaultNodeHome))
	rootCmd.AddCommand(genutilcli.MigrateGenesisCmd())
	rootCmd.AddCommand(
		genutilcli.GenTxCmd(
			app.ModuleBasics, encodingConfig.TxConfig,
			banktypes.GenesisBalancesIterator{}, app.DefaultNodeHome,
		),
	)
	rootCmd.AddCommand(genutilcli.ValidateGenesisCmd(app.ModuleBasics))
	// AddGenesisAccountCmd allows users to add accounts to the genesis file
	rootCmd.AddCommand(AddGenesisAccountCmd(ctx, cdc, app.DefaultNodeHome, app.DefaultCLIHome))
	rootCmd.AddCommand(cli.NewCompletionCmd(rootCmd, true))
	rootCmd.AddCommand(testnetCmd(app.ModuleBasics, banktypes.GenesisBalancesIterator{}))
	rootCmd.AddCommand(testnetCmd(app.ModuleBasics, banktypes.GenesisBalancesIterator{}))
	rootCmd.AddCommand(debug.Cmd())

	a := appCreator{encCfg: encodingConfig}
	server.AddCommands(rootCmd, app.DefaultNodeHome, a.newApp, a.appExport, crisis.AddModuleInitFlags)

	// prepare and add flags
	executor := cli.PrepareBaseCmd(rootCmd, "NS", DefaultNodeHome)
	err := executor.Execute()
	if err != nil {
		// handle with #870
		panic(err)
	}
}

type appCreator struct {
	encCfg params.EncodingConfig
}

// newApp is an AppCreator
func (a appCreator) newApp(logger log.Logger, db dbm.DB, traceStore io.Writer, appOpts servertypes.AppOptions) servertypes.Application {
	return app.NewPylonsApp(
		logger, db,
		a.encCfg,
	)
}

// appExport creates a new simapp (optionally at a given height)
func (a appCreator) appExport(
	logger log.Logger, db dbm.DB, traceStore io.Writer, height int64, forZeroHeight bool, jailAllowedAddrs []string,
	appOpts servertypes.AppOptions) (servertypes.ExportedApp, error) {

	var anApp *app.PylonsApp

	if height != -1 {
		anApp = app.NewPylonsApp(logger, db, a.encCfg)

		if err := anApp.LoadHeight(height); err != nil {
			return servertypes.ExportedApp{}, err
		}
	} else {
		anApp = app.NewPylonsApp(logger, db, a.encCfg)
	}

	return anApp.ExportAppStateAndValidators(forZeroHeight, jailAllowedAddrs)
}

package app_test

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
	"testing"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/simapp"
	"github.com/cosmos/cosmos-sdk/store"
	simulation2 "github.com/cosmos/cosmos-sdk/types/simulation"
	"github.com/cosmos/cosmos-sdk/x/simulation"
	"github.com/stretchr/testify/require"
	"github.com/tendermint/tendermint/libs/log"
	dbm "github.com/tendermint/tm-db"

	"github.com/Pylons-tech/pylons/app"
	pylons "github.com/Pylons-tech/pylons/app"
)

func init() {
	simapp.GetSimulatorFlags()
}

func TestFullAppSimulation(t *testing.T) {
	// -Enabled=true -NumBlocks=1000 -BlockSize=200 \
	// -Period=1 -Commit=true -Seed=57 -v -timeout 24h
	simapp.FlagEnabledValue = true
	simapp.FlagNumBlocksValue = 20
	simapp.FlagBlockSizeValue = 25
	simapp.FlagCommitValue = true
	simapp.FlagVerboseValue = true
	simapp.FlagPeriodValue = 10
	simapp.FlagSeedValue = 10
	fullAppSimulation(t, true)
}

func fullAppSimulation(tb testing.TB, is_testing bool) {
	config, db, dir, logger, _, err := simapp.SetupSimulation("goleveldb-app-sim", "Simulation")
	if err != nil {
		tb.Fatalf("simulation setup failed: %s", err.Error())
	}

	defer func() {
		db.Close()
		err = os.RemoveAll(dir)
		if err != nil {
			tb.Fatal(err)
		}
	}()

	var pylonsApp = app.New(
		logger,
		db,
		nil,
		true, // load latest
		map[int64]bool{},
		pylons.DefaultNodeHome,
		simapp.FlagPeriodValue,
		app.MakeEncodingConfig(),
		simapp.EmptyAppOptions{},
		interBlockCacheOpt(),
	)

	// Run randomized simulation:
	_, simParams, simErr := simulation.SimulateFromSeed(
		tb,
		os.Stdout,
		pylonsApp.BaseApp,
		simapp.AppStateFn(pylonsApp.AppCodec(), pylonsApp.SimulationManager()),
		simulation2.RandomAccounts, // Replace with own random account function if using keys other than secp256k1
		simapp.SimulationOperations(pylonsApp, pylonsApp.AppCodec(), config),
		pylonsApp.ModuleAccountAddrs(),
		config,
		pylonsApp.AppCodec(),
	)

	// export state and simParams before the simulation error is checked
	if err = simapp.CheckExportSimulation(pylonsApp, config, simParams); err != nil {
		tb.Fatal(err)
	}

	if simErr != nil {
		tb.Fatal(simErr)
	}

	if config.Commit {
		simapp.PrintStats(db)
	}
}

// Profile with:
// /usr/local/go/bin/go test -benchmem -run=^$ github.com/cosmos/cosmos-sdk/GaiaApp -bench ^BenchmarkFullAppSimulation$ -Commit=true -cpuprofile cpu.out
func BenchmarkFullAppSimulation(b *testing.B) {
	config, db, dir, logger, _, err := simapp.SetupSimulation("goleveldb-app-sim", "Simulation")
	if err != nil {
		b.Fatalf("simulation setup failed: %s", err.Error())
	}

	defer func() {
		db.Close()
		err = os.RemoveAll(dir)
		if err != nil {
			b.Fatal(err)
		}
	}()

	encoding := app.MakeEncodingConfig()
	pylonsApp := pylons.New(logger, db, nil, true, map[int64]bool{}, pylons.DefaultNodeHome, simapp.FlagPeriodValue, encoding, simapp.EmptyAppOptions{}, interBlockCacheOpt())

	// Run randomized simulation:
	_, simParams, simErr := simulation.SimulateFromSeed(
		b,
		os.Stdout,
		pylonsApp.BaseApp,
		simapp.AppStateFn(pylonsApp.AppCodec(), pylonsApp.SimulationManager()),
		simulation2.RandomAccounts, // Replace with own random account function if using keys other than secp256k1
		simapp.SimulationOperations(pylonsApp, pylonsApp.AppCodec(), config),
		pylonsApp.ModuleAccountAddrs(),
		config,
		pylonsApp.AppCodec(),
	)

	// export state and simParams before the simulation error is checked
	if err = simapp.CheckExportSimulation(pylonsApp, config, simParams); err != nil {
		b.Fatal(err)
	}

	if simErr != nil {
		b.Fatal(simErr)
	}

	if config.Commit {
		simapp.PrintStats(db)
	}
}

// interBlockCacheOpt returns a BaseApp option function that sets the persistent
// inter-block write-through cache.
func interBlockCacheOpt() func(*baseapp.BaseApp) {
	return baseapp.SetInterBlockCache(store.NewCommitKVStoreCacheManager())
}

func TestAppStateDeterminism(t *testing.T) {
	if !simapp.FlagEnabledValue {
		t.Skip("skipping application simulation")
	}

	config := simapp.NewConfigFromFlags()
	config.InitialBlockHeight = 1
	config.ExportParamsPath = ""
	config.OnOperation = false
	config.AllInvariants = false
	config.ChainID = "pylons-app"

	numSeeds := 3
	numTimesToRunPerSeed := 5
	appHashList := make([]json.RawMessage, numTimesToRunPerSeed)

	for i := 0; i < numSeeds; i++ {
		config.Seed = rand.Int63()

		for j := 0; j < numTimesToRunPerSeed; j++ {
			var logger log.Logger
			if simapp.FlagVerboseValue {
				logger = log.TestingLogger()
			} else {
				logger = log.NewNopLogger()
			}

			db := dbm.NewMemDB()
			encoding := app.MakeEncodingConfig()
			pylonsApp := pylons.New(logger, db, nil, true, map[int64]bool{}, pylons.DefaultNodeHome, simapp.FlagPeriodValue, encoding, simapp.EmptyAppOptions{}, interBlockCacheOpt())

			fmt.Printf(
				"running non-determinism simulation; seed %d: %d/%d, attempt: %d/%d\n",
				config.Seed, i+1, numSeeds, j+1, numTimesToRunPerSeed,
			)

			_, _, err := simulation.SimulateFromSeed(
				t,
				os.Stdout,
				pylonsApp.BaseApp,
				simapp.AppStateFn(pylonsApp.AppCodec(), pylonsApp.SimulationManager()),
				simulation2.RandomAccounts, // Replace with own random account function if using keys other than secp256k1
				simapp.SimulationOperations(pylonsApp, pylonsApp.AppCodec(), config),
				pylonsApp.ModuleAccountAddrs(),
				config,
				pylonsApp.AppCodec(),
			)
			require.NoError(t, err)

			if config.Commit {
				simapp.PrintStats(db)
			}

			appHash := pylonsApp.LastCommitID().Hash
			appHashList[j] = appHash

			if j != 0 {
				require.Equal(
					t, string(appHashList[0]), string(appHashList[j]),
					"non-determinism in seed %d: %d/%d, attempt: %d/%d\n", config.Seed, i+1, numSeeds, j+1, numTimesToRunPerSeed,
				)
			}
		}
	}
}

package app_test

import (
	"encoding/json"
	"fmt"
	"math/rand"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/simapp"
	"github.com/cosmos/cosmos-sdk/store"
	simulation2 "github.com/cosmos/cosmos-sdk/types/simulation"
	"github.com/cosmos/cosmos-sdk/x/simulation"
	"github.com/stretchr/testify/require"
	"github.com/tendermint/spm/cosmoscmd"
	"github.com/tendermint/tendermint/libs/log"
	dbm "github.com/tendermint/tm-db"

	pylons "github.com/Pylons-tech/pylons/app"

	"os"
	"testing"
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

	// fauxMerkleModeOpt returns a BaseApp option to use a dbStoreAdapter instead of
	// an IAVLStore for faster simulation speed.
	fauxMerkleModeOpt := func(bapp *baseapp.BaseApp) {
		if is_testing {
			bapp.SetFauxMerkleMode()
		}
	}

	cmdApp := pylons.New(
		logger,
		db,
		nil,
		true, // load latest
		map[int64]bool{},
		pylons.DefaultNodeHome,
		simapp.FlagPeriodValue,
		cosmoscmd.MakeEncodingConfig(pylons.ModuleBasics),
		simapp.EmptyAppOptions{},
		interBlockCacheOpt(),
		fauxMerkleModeOpt)

	var app *pylons.App
	switch cmdApp.(type) {
	case *pylons.App:
		app = cmdApp.(*pylons.App)
	default:
		panic("imported simApp incorrectly")
	}


	// Run randomized simulation:
	_, simParams, simErr := simulation.SimulateFromSeed(
		tb,
		os.Stdout,
		app.BaseApp,
		simapp.AppStateFn(app.AppCodec(), app.SimulationManager()),
		simulation2.RandomAccounts, // Replace with own random account function if using keys other than secp256k1
		simapp.SimulationOperations(app, app.AppCodec(), config),
		app.ModuleAccountAddrs(),
		config,
		app.AppCodec(),
	)

	// export state and simParams before the simulation error is checked
	if err = simapp.CheckExportSimulation(app, config, simParams); err != nil {
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

	encoding := cosmoscmd.MakeEncodingConfig(pylons.ModuleBasics)
	cmdApp := pylons.New(logger, db, nil, true, map[int64]bool{}, pylons.DefaultNodeHome, simapp.FlagPeriodValue, encoding, simapp.EmptyAppOptions{}, interBlockCacheOpt())

	var app *pylons.App
	switch cmdApp.(type) {
	case *pylons.App:
		app = cmdApp.(*pylons.App)
	default:
		panic("imported simApp incorrectly")
	}

	// Run randomized simulation:
	_, simParams, simErr := simulation.SimulateFromSeed(
		b,
		os.Stdout,
		app.BaseApp,
		simapp.AppStateFn(app.AppCodec(), app.SimulationManager()),
		simulation2.RandomAccounts, // Replace with own random account function if using keys other than secp256k1
		simapp.SimulationOperations(app, app.AppCodec(), config),
		app.ModuleAccountAddrs(),
		config,
		app.AppCodec(),
	)

	// export state and simParams before the simulation error is checked
	if err = simapp.CheckExportSimulation(app, config, simParams); err != nil {
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
			encoding := cosmoscmd.MakeEncodingConfig(pylons.ModuleBasics)
			cmdApp := pylons.New(logger, db, nil, true, map[int64]bool{}, pylons.DefaultNodeHome, simapp.FlagPeriodValue, encoding, simapp.EmptyAppOptions{}, interBlockCacheOpt())

			var app *pylons.App
			switch cmdApp.(type) {
			case *pylons.App:
				app = cmdApp.(*pylons.App)
			default:
				panic("imported simApp incorrectly")
			}

			fmt.Printf(
				"running non-determinism simulation; seed %d: %d/%d, attempt: %d/%d\n",
				config.Seed, i+1, numSeeds, j+1, numTimesToRunPerSeed,
			)

			_, _, err := simulation.SimulateFromSeed(
				t,
				os.Stdout,
				app.BaseApp,
				simapp.AppStateFn(app.AppCodec(), app.SimulationManager()),
				simulation2.RandomAccounts, // Replace with own random account function if using keys other than secp256k1
				simapp.SimulationOperations(app, app.AppCodec(), config),
				app.ModuleAccountAddrs(),
				config,
				app.AppCodec(),
			)
			require.NoError(t, err)

			if config.Commit {
				simapp.PrintStats(db)
			}

			appHash := app.LastCommitID().Hash
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

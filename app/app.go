package app

import (
	"encoding/json"
	appParams "github.com/Pylons-tech/pylons/app/params"
	"github.com/cosmos/cosmos-sdk/codec/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/ante"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
	genutiltypes "github.com/cosmos/cosmos-sdk/x/genutil/types"
	"github.com/cosmos/cosmos-sdk/x/params"
	"os"

	"github.com/tendermint/tendermint/libs/log"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"

	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/simapp"
	"github.com/cosmos/cosmos-sdk/types/module"

	authkeeper "github.com/cosmos/cosmos-sdk/x/auth/Keeper"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	"github.com/cosmos/cosmos-sdk/x/bank"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"

	distr "github.com/cosmos/cosmos-sdk/x/distribution"
	distrkeeper "github.com/cosmos/cosmos-sdk/x/distribution/keeper"
	distrtypes "github.com/cosmos/cosmos-sdk/x/distribution/types"

	"github.com/cosmos/cosmos-sdk/x/genutil"

	paramskeeper "github.com/cosmos/cosmos-sdk/x/params/keeper"
	paramstypes "github.com/cosmos/cosmos-sdk/x/params/types"

	"github.com/cosmos/cosmos-sdk/x/slashing"
	slashingkeeper "github.com/cosmos/cosmos-sdk/x/slashing/Keeper"
	slashingtypes "github.com/cosmos/cosmos-sdk/x/slashing/types"

	"github.com/cosmos/cosmos-sdk/x/staking"
	stakingkeeper "github.com/cosmos/cosmos-sdk/x/staking/keeper"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"

	"github.com/Pylons-tech/pylons/x/pylons"
	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	pylonskeeper "github.com/Pylons-tech/pylons/x/pylons/keep"

	bam "github.com/cosmos/cosmos-sdk/baseapp"
	servertypes "github.com/cosmos/cosmos-sdk/server/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
	tmos "github.com/tendermint/tendermint/libs/os"
	dbm "github.com/tendermint/tm-db"
)

const (
	appName = "pylons"
)

// basic configurations to manage app
var (
	// default home directories for the application CLI
	DefaultCLIHome = os.ExpandEnv("$HOME/.pylonscli")

	// DefaultNodeHome sets the folder where the applcation data and configuration will be stored
	DefaultNodeHome = os.ExpandEnv("$HOME/.pylonsd")

	// NewBasicManager is in charge of setting up basic module elemnets
	ModuleBasics = module.NewBasicManager(
		genutil.AppModuleBasic{},
		auth.AppModuleBasic{},
		bank.AppModuleBasic{},
		staking.AppModuleBasic{},
		distr.AppModuleBasic{},
		params.AppModuleBasic{},
		slashing.AppModuleBasic{},
		pylons.AppModuleBasic{},
	)
	// account permissions
	maccPerms = map[string][]string{
		authtypes.FeeCollectorName:     nil,
		distrtypes.ModuleName:          nil,
		stakingtypes.BondedPoolName:    {authtypes.Burner, authtypes.Staking},
		stakingtypes.NotBondedPoolName: {authtypes.Burner, authtypes.Staking},
	}
)

// PylonsApp is the top level pylons app
type PylonsApp struct {
	*bam.BaseApp
	cdc               *codec.LegacyAmino
	appCodec          codec.Marshaler
	interfaceRegistry types.InterfaceRegistry

	// keys to access the substores
	keys  map[string]*sdk.KVStoreKey
	tkeys map[string]*sdk.TransientStoreKey

	// subspaces
	subspaces map[string]paramstypes.Subspace

	// Keepers
	accountKeeper  authkeeper.AccountKeeper
	bankKeeper     bankkeeper.Keeper
	stakingKeeper  stakingkeeper.Keeper
	slashingKeeper slashingkeeper.Keeper
	distrKeeper    distrkeeper.Keeper
	paramsKeeper   paramskeeper.Keeper
	plnKeeper      pylonskeeper.Keeper

	// Module Manager
	mm *module.Manager

	// simulation manager
	sm *module.SimulationManager
}

// verify app interface at compile time
var _ simapp.App = (*PylonsApp)(nil)

// NewPylonsApp is a constructor function for PylonsApp
func NewPylonsApp(logger log.Logger, db dbm.DB, encodingConfig appParams.EncodingConfig, baseAppOptions ...func(*bam.BaseApp)) *PylonsApp {
	// First define the top level codec that will be shared by the different modules
	cdc := encodingConfig.Amino
	appCodec := encodingConfig.Marshaler
	interfaceRegistry := encodingConfig.InterfaceRegistry

	// BaseApp handles interactions with Tendermint through the ABCI protocol
	bApp := bam.NewBaseApp(appName, logger, db, encodingConfig.TxConfig.TxDecoder())

	bApp.SetAppVersion("v0.0.1")

	stringKeys := []string{
		authtypes.StoreKey, stakingtypes.StoreKey,
		banktypes.StoreKey, distrtypes.StoreKey,
		slashingtypes.StoreKey, paramstypes.StoreKey,
		pylons.StoreKey,
	}
	// pylons keys
	stringKeys = append(stringKeys, pylonskeeper.StoreKeyList...)

	keys := sdk.NewKVStoreKeys(stringKeys...)
	tkeys := sdk.NewTransientStoreKeys(paramstypes.TStoreKey)

	// Here you initialize your application with the store keys it requires
	var app = &PylonsApp{
		BaseApp:           bApp,
		cdc:               cdc,
		appCodec:          appCodec,
		interfaceRegistry: interfaceRegistry,
		keys:              keys,
		tkeys:             tkeys,
		subspaces:         make(map[string]paramstypes.Subspace),
	}

	// The ParamsKeeper handles parameter storage for the application
	app.paramsKeeper = paramskeeper.NewKeeper(nil, app.cdc, keys[paramstypes.StoreKey], tkeys[paramstypes.TStoreKey])
	// Set specific supspaces
	app.subspaces[authtypes.ModuleName] = app.paramsKeeper.Subspace(authtypes.ModuleName)
	app.subspaces[banktypes.ModuleName] = app.paramsKeeper.Subspace(banktypes.ModuleName)
	app.subspaces[stakingtypes.ModuleName] = app.paramsKeeper.Subspace(stakingtypes.ModuleName)
	app.subspaces[distrtypes.ModuleName] = app.paramsKeeper.Subspace(distrtypes.ModuleName)
	app.subspaces[slashingtypes.ModuleName] = app.paramsKeeper.Subspace(slashingtypes.ModuleName)

	// The AccountKeeper handles address -> account lookups
	app.accountKeeper = authkeeper.NewAccountKeeper(
		app.appCodec,
		keys[authtypes.StoreKey],
		app.subspaces[authtypes.ModuleName],
		authtypes.ProtoBaseAccount,
		maccPerms,
	)

	// The BankKeeper allows you perform sdk.Coins interactions
	app.bankKeeper = bankkeeper.NewBaseKeeper(
		app.appCodec,
		keys[banktypes.StoreKey],
		app.accountKeeper,
		app.subspaces[banktypes.ModuleName],
		app.ModuleAccountAddrs(),
	)

	// The staking keeper
	stakingKeeper := stakingkeeper.NewKeeper(
		app.appCodec,
		keys[stakingtypes.StoreKey],
		app.accountKeeper,
		app.bankKeeper,
		app.subspaces[stakingtypes.ModuleName],
	)

	app.distrKeeper = distrkeeper.NewKeeper(
		app.appCodec,
		keys[distrtypes.StoreKey],
		app.subspaces[distrtypes.ModuleName],
		app.accountKeeper,
		app.bankKeeper,
		app.stakingKeeper,
		authtypes.FeeCollectorName,
		app.ModuleAccountAddrs(),
	)

	app.slashingKeeper = slashingkeeper.NewKeeper(
		app.appCodec,
		keys[slashingtypes.StoreKey],
		&stakingKeeper,
		app.subspaces[slashingtypes.ModuleName],
	)

	// register the staking hooks
	// NOTE: stakingKeeper above is passed by reference, so that it will contain these hooks
	app.stakingKeeper = *stakingKeeper.SetHooks(
		stakingtypes.NewMultiStakingHooks(
			app.distrKeeper.Hooks(),
			app.slashingKeeper.Hooks()),
	)

	// The pylonsKeeper is the Keeper from the module for this tutorial
	// It handles interactions with the namestore
	app.plnKeeper = pylonskeeper.NewKeeper(
		app.bankKeeper,
		app.cdc,
		keys,
	)
	app.mm = module.NewManager(
		genutil.NewAppModule(app.accountKeeper, app.stakingKeeper, app.BaseApp.DeliverTx, encodingConfig.TxConfig),
		auth.NewAppModule(app.appCodec, app.accountKeeper, nil),
		bank.NewAppModule(app.appCodec, app.bankKeeper, app.accountKeeper),
		pylons.NewAppModule(app.plnKeeper, app.bankKeeper),
		distr.NewAppModule(app.appCodec, app.distrKeeper, app.accountKeeper, app.bankKeeper, app.stakingKeeper),
		slashing.NewAppModule(app.appCodec, app.slashingKeeper, app.accountKeeper, app.bankKeeper, app.stakingKeeper),
		staking.NewAppModule(app.appCodec, app.stakingKeeper, app.accountKeeper, app.bankKeeper),
	)

	app.mm.SetOrderBeginBlockers(distrtypes.ModuleName, slashingtypes.ModuleName)
	app.mm.SetOrderEndBlockers(stakingtypes.ModuleName)

	// Sets the order of Genesis - Order matters, genutil is to always come last
	// NOTE: The genutils moodule must occur after staking so that pools are
	// properly initialized with tokens from genesis accounts.
	app.mm.SetOrderInitGenesis(
		distrtypes.ModuleName,
		stakingtypes.ModuleName,
		authtypes.ModuleName,
		banktypes.ModuleName,
		slashingtypes.ModuleName,
		genutiltypes.ModuleName,
		pylons.ModuleName,
	)

	// register all module routes and module queriers
	app.mm.RegisterRoutes(app.Router(), app.QueryRouter(), app.cdc)

	// The initChainer handles translating the genesis.json file into initial state for the network
	app.SetInitChainer(app.InitChainer)
	app.SetBeginBlocker(app.BeginBlocker)
	app.SetEndBlocker(app.EndBlocker)

	// The AnteHandler handles signature verification and transaction pre-processing
	app.SetAnteHandler(
		handlers.NewAnteHandler(
			app.accountKeeper,
			app.bankKeeper,
			ante.DefaultSigVerificationGasConsumer,
		),
	)

	// initialize stores
	app.MountKVStores(keys)
	app.MountTransientStores(tkeys)

	err := app.LoadLatestVersion()
	if err != nil {
		tmos.Exit(err.Error())
	}

	return app

}

// GenesisState represents chain state at the start of the chain. Any initial state (account balances) are stored here.
type GenesisState map[string]json.RawMessage

// NewDefaultGenesisState returns new default genesis state
func NewDefaultGenesisState(cdc codec.JSONMarshaler) GenesisState {
	return ModuleBasics.DefaultGenesis(cdc)
}

// InitChainer init chain with genesis state
func (app *PylonsApp) InitChainer(ctx sdk.Context, req abci.RequestInitChain) abci.ResponseInitChain {
	var genesisState GenesisState

	err := app.cdc.UnmarshalJSON(req.AppStateBytes, &genesisState)
	if err != nil {
		panic(err)
	}

	return app.mm.InitGenesis(ctx, app.appCodec, genesisState)
}

// BeginBlocker is a function to begin block
func (app *PylonsApp) BeginBlocker(ctx sdk.Context, req abci.RequestBeginBlock) abci.ResponseBeginBlock {
	return app.mm.BeginBlock(ctx, req)
}

// EndBlocker is a function to end block
func (app *PylonsApp) EndBlocker(ctx sdk.Context, req abci.RequestEndBlock) abci.ResponseEndBlock {
	return app.mm.EndBlock(ctx, req)
}

// GetKey returns the KVStoreKey for the provided store key
func (app *PylonsApp) GetKey(storeKey string) *sdk.KVStoreKey {
	return app.keys[storeKey]
}

// GetTKey returns the TransientStoreKey for the provided store key
func (app *PylonsApp) GetTKey(storeKey string) *sdk.TransientStoreKey {
	return app.tkeys[storeKey]
}

// LoadHeight loads data at a height
func (app *PylonsApp) LoadHeight(height int64) error {
	return app.LoadVersion(height)
}

// Codec returns simapp's codec
func (app *PylonsApp) Codec() codec.JSONMarshaler {
	return app.appCodec
}

// SimulationManager implements the SimulationApp interface
func (app *PylonsApp) SimulationManager() *module.SimulationManager {
	return app.sm
}

// ModuleAccountAddrs returns all the app's module account addresses.
func (app *PylonsApp) ModuleAccountAddrs() map[string]bool {
	modAccAddrs := make(map[string]bool)
	for acc := range maccPerms {
		modAccAddrs[authtypes.NewModuleAddress(acc).String()] = true
	}

	return modAccAddrs
}

func (app *PylonsApp) LegacyAmino() *codec.LegacyAmino {
	return app.cdc
}

// ExportAppStateAndValidators export app state and validators
func (app *PylonsApp) ExportAppStateAndValidators(
	forZeroHeight bool, jailAllowedAddrs []string,
) (servertypes.ExportedApp, error) {

	// as if they could withdraw from the start of the next block
	ctx := app.NewContext(true, tmproto.Header{Height: app.LastBlockHeight()})

	// We export at last height + 1, because that's the height at which
	// Tendermint will start InitChain.
	height := app.LastBlockHeight() + 1
	if forZeroHeight {
		height = 0
		app.prepForZeroHeightGenesis(ctx, jailAllowedAddrs)
	}

	genState := app.mm.ExportGenesis(ctx, app.appCodec)
	appState, err := json.MarshalIndent(genState, "", "  ")
	if err != nil {
		return servertypes.ExportedApp{}, err
	}

	validators, err := staking.WriteValidators(ctx, app.stakingKeeper)
	if err != nil {
		return servertypes.ExportedApp{}, err
	}
	return servertypes.ExportedApp{
		AppState:        appState,
		Validators:      validators,
		Height:          height,
		ConsensusParams: app.BaseApp.GetConsensusParams(ctx),
	}, nil
}

// prepare for fresh start at zero height
// NOTE zero height genesis is a temporary feature which will be deprecated
//      in favour of export at a block height
func (app *PylonsApp) prepForZeroHeightGenesis(ctx sdk.Context, jailAllowedAddrs []string) {
	applyAllowedAddrs := false

	// check if there is a allowed address list
	if len(jailAllowedAddrs) > 0 {
		applyAllowedAddrs = true
	}

	allowedAddrsMap := make(map[string]bool)

	for _, addr := range jailAllowedAddrs {
		_, err := sdk.ValAddressFromBech32(addr)
		if err != nil {
			tmos.Exit(err.Error())
		}
		allowedAddrsMap[addr] = true
	}

	/* Handle fee distribution state. */

	// withdraw all validator commission
	app.stakingKeeper.IterateValidators(ctx, func(_ int64, val stakingtypes.ValidatorI) (stop bool) {
		_, err := app.distrKeeper.WithdrawValidatorCommission(ctx, val.GetOperator())
		if err != nil {
			panic(err)
		}
		return false
	})

	// withdraw all delegator rewards
	dels := app.stakingKeeper.GetAllDelegations(ctx)
	for _, delegation := range dels {
		_, err := app.distrKeeper.WithdrawDelegationRewards(ctx, delegation.GetDelegatorAddr(), delegation.GetValidatorAddr())
		if err != nil {
			panic(err)
		}
	}

	// clear validator slash events
	app.distrKeeper.DeleteAllValidatorSlashEvents(ctx)

	// clear validator historical rewards
	app.distrKeeper.DeleteAllValidatorHistoricalRewards(ctx)

	// set context height to zero
	height := ctx.BlockHeight()
	ctx = ctx.WithBlockHeight(0)

	// reinitialize all validators
	app.stakingKeeper.IterateValidators(ctx, func(_ int64, val stakingtypes.ValidatorI) (stop bool) {
		// donate any unwithdrawn outstanding reward fraction tokens to the community pool
		scraps := app.distrKeeper.GetValidatorOutstandingRewardsCoins(ctx, val.GetOperator())
		feePool := app.distrKeeper.GetFeePool(ctx)
		feePool.CommunityPool = feePool.CommunityPool.Add(scraps...)
		app.distrKeeper.SetFeePool(ctx, feePool)

		app.distrKeeper.Hooks().AfterValidatorCreated(ctx, val.GetOperator())
		return false
	})

	// reinitialize all delegations
	for _, del := range dels {
		app.distrKeeper.Hooks().BeforeDelegationCreated(ctx, del.GetDelegatorAddr(), del.GetValidatorAddr())
		app.distrKeeper.Hooks().AfterDelegationModified(ctx, del.GetDelegatorAddr(), del.GetValidatorAddr())
	}

	// reset context height
	ctx = ctx.WithBlockHeight(height)

	/* Handle staking state. */

	// iterate through redelegations, reset creation height
	app.stakingKeeper.IterateRedelegations(ctx, func(_ int64, red stakingtypes.Redelegation) (stop bool) {
		for i := range red.Entries {
			red.Entries[i].CreationHeight = 0
		}
		app.stakingKeeper.SetRedelegation(ctx, red)
		return false
	})

	// iterate through unbonding delegations, reset creation height
	app.stakingKeeper.IterateUnbondingDelegations(ctx, func(_ int64, ubd stakingtypes.UnbondingDelegation) (stop bool) {
		for i := range ubd.Entries {
			ubd.Entries[i].CreationHeight = 0
		}
		app.stakingKeeper.SetUnbondingDelegation(ctx, ubd)
		return false
	})

	// Iterate through validators by power descending, reset bond heights, and
	// update bond intra-tx counters.
	store := ctx.KVStore(app.keys[stakingtypes.StoreKey])
	iter := sdk.KVStoreReversePrefixIterator(store, stakingtypes.ValidatorsKey)
	counter := int16(0)

	for ; iter.Valid(); iter.Next() {
		addr := sdk.ValAddress(iter.Key()[1:])
		validator, found := app.stakingKeeper.GetValidator(ctx, addr)
		if !found {
			panic("expected validator, not found")
		}

		validator.UnbondingHeight = 0
		if applyAllowedAddrs && !allowedAddrsMap[addr.String()] {
			validator.Jailed = true
		}

		app.stakingKeeper.SetValidator(ctx, validator)
		counter++
	}

	iter.Close()

	if _, err := app.stakingKeeper.ApplyAndReturnValidatorSetUpdates(ctx); err != nil {
		panic(err)
	}

	/* Handle slashing state. */

	// reset start height on signing infos
	app.slashingKeeper.IterateValidatorSigningInfos(
		ctx,
		func(addr sdk.ConsAddress, info slashingtypes.ValidatorSigningInfo) (stop bool) {
			info.StartHeight = 0
			app.slashingKeeper.SetValidatorSigningInfo(ctx, addr, info)
			return false
		},
	)
}

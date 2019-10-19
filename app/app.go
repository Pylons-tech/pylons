package app

import (
	"encoding/json"

	"github.com/tendermint/tendermint/libs/log"

	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/bank"
	"github.com/cosmos/cosmos-sdk/x/params"
	"github.com/cosmos/cosmos-sdk/x/staking"
	tmtypes "github.com/tendermint/tendermint/types"

	"github.com/MikeSofaer/pylons/x/pylons"
	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/keep"

	bam "github.com/cosmos/cosmos-sdk/baseapp"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
	cmn "github.com/tendermint/tendermint/libs/common"
	dbm "github.com/tendermint/tendermint/libs/db"
)

const (
	appName = "pylons"
)

// PylonsApp is the top level pylons app
type PylonsApp struct {
	*bam.BaseApp
	cdc *codec.Codec

	keyMain           *sdk.KVStoreKey
	keyAccount        *sdk.KVStoreKey
	keyPylonsCookbook *sdk.KVStoreKey
	keyPylonsRecipe   *sdk.KVStoreKey
	keyPylonsItem     *sdk.KVStoreKey
	keyFeeCollection  *sdk.KVStoreKey
	keyParams         *sdk.KVStoreKey
	keyExecution      *sdk.KVStoreKey
	keyTrade          *sdk.KVStoreKey
	tkeyParams        *sdk.TransientStoreKey

	accountKeeper       auth.AccountKeeper
	bankKeeper          bank.Keeper
	feeCollectionKeeper auth.FeeCollectionKeeper
	paramsKeeper        params.Keeper
	plnKeeper           keep.Keeper
}

// NewPylonsApp is a constructor function for PylonsApp
func NewPylonsApp(logger log.Logger, db dbm.DB) *PylonsApp {
	// First define the top level codec that will be shared by the different modules
	cdc := MakeCodec()

	// BaseApp handles interactions with Tendermint through the ABCI protocol
	bApp := bam.NewBaseApp(appName, logger, db, auth.DefaultTxDecoder(cdc))

	// Here you initialize your application with the store keys it requires
	var app = &PylonsApp{
		BaseApp: bApp,
		cdc:     cdc,

		keyMain:           sdk.NewKVStoreKey("main"),
		keyAccount:        sdk.NewKVStoreKey("acc"),
		keyPylonsCookbook: sdk.NewKVStoreKey("pylons"),
		keyPylonsRecipe:   sdk.NewKVStoreKey("pylons_recipe"),
		keyPylonsItem:     sdk.NewKVStoreKey("pylons_item"),
		keyExecution:      sdk.NewKVStoreKey("pylons_execution"),
		keyTrade:          sdk.NewKVStoreKey("pylons_trade"),
		keyFeeCollection:  sdk.NewKVStoreKey("fee_collection"),
		keyParams:         sdk.NewKVStoreKey("params"),
		tkeyParams:        sdk.NewTransientStoreKey("transient_params"),
	}

	// The ParamsKeeper handles parameter storage for the application
	app.paramsKeeper = params.NewKeeper(app.cdc, app.keyParams, app.tkeyParams)

	// The AccountKeeper handles address -> account lookups
	app.accountKeeper = auth.NewAccountKeeper(
		app.cdc,
		app.keyAccount,
		app.paramsKeeper.Subspace(auth.DefaultParamspace),
		auth.ProtoBaseAccount,
	)

	// The BankKeeper allows you perform sdk.Coins interactions
	app.bankKeeper = bank.NewBaseKeeper(
		app.accountKeeper,
		app.paramsKeeper.Subspace(bank.DefaultParamspace),
		bank.DefaultCodespace,
	)

	// The FeeCollectionKeeper collects transaction fees and renders them to the fee distribution module
	app.feeCollectionKeeper = auth.NewFeeCollectionKeeper(cdc, app.keyFeeCollection)

	// The pylonsKeeper is the Keeper from the module for this tutorial
	// It handles interactions with the namestore
	app.plnKeeper = keep.NewKeeper(
		app.bankKeeper,
		app.keyPylonsCookbook,
		app.keyPylonsRecipe,
		app.keyPylonsItem,
		app.keyExecution,
		app.keyTrade,
		app.cdc,
	)

	// The Custom AnteHandler handles signature verification and transaction pre-processing
	// and gives an exception for get pylons message
	app.SetAnteHandler(handlers.NewCustomAnteHandler(app.accountKeeper, app.feeCollectionKeeper, logger))
	// The app.Router is the main transaction router where each module registers its routes
	// Register the bank and pylons routes here
	app.Router().
		AddRoute("bank", bank.NewHandler(app.bankKeeper)).
		AddRoute("pylons", pylons.NewHandler(app.plnKeeper))

	// The app.QueryRouter is the main query router where each module registers its routes
	app.QueryRouter().
		AddRoute("acc", auth.NewQuerier(app.accountKeeper)).
		AddRoute("pylons", pylons.NewQuerier(app.plnKeeper))

	// The initChainer handles translating the genesis.json file into initial state for the network
	app.SetInitChainer(app.initChainer)

	app.MountStores(
		app.keyMain,
		app.keyAccount,
		app.keyPylonsCookbook,
		app.keyPylonsRecipe,
		app.keyFeeCollection,
		app.keyPylonsItem,
		app.keyExecution,
		app.keyTrade,
		app.keyParams,
		app.tkeyParams,
	)

	err := app.LoadLatestVersion(app.keyMain)
	if err != nil {
		cmn.Exit(err.Error())
	}

	return app

}

// GenesisState represents chain state at the start of the chain. Any initial state (account balances) are stored here.
type GenesisState struct {
	AuthData auth.GenesisState   `json:"auth"`
	BankData bank.GenesisState   `json:"bank"`
	Accounts []*auth.BaseAccount `json:"accounts"`
}

func (app *PylonsApp) initChainer(ctx sdk.Context, req abci.RequestInitChain) abci.ResponseInitChain {
	stateJSON := req.AppStateBytes

	genesisState := new(GenesisState)
	err := app.cdc.UnmarshalJSON(stateJSON, genesisState)
	if err != nil {
		panic(err)
	}

	for _, acc := range genesisState.Accounts {
		acc.AccountNumber = app.accountKeeper.GetNextAccountNumber(ctx)
		app.accountKeeper.SetAccount(ctx, acc)
	}

	auth.InitGenesis(ctx, app.accountKeeper, app.feeCollectionKeeper, genesisState.AuthData)
	bank.InitGenesis(ctx, app.bankKeeper, genesisState.BankData)

	return abci.ResponseInitChain{}
}

// ExportAppStateAndValidators does the things
func (app *PylonsApp) ExportAppStateAndValidators() (appState json.RawMessage, validators []tmtypes.GenesisValidator, err error) {
	ctx := app.NewContext(true, abci.Header{})
	accounts := []*auth.BaseAccount{}

	appendAccountsFn := func(acc auth.Account) bool {
		account := &auth.BaseAccount{
			Address: acc.GetAddress(),
			Coins:   acc.GetCoins(),
		}

		accounts = append(accounts, account)
		return false
	}

	app.accountKeeper.IterateAccounts(ctx, appendAccountsFn)

	genState := GenesisState{
		Accounts: accounts,
		AuthData: auth.DefaultGenesisState(),
		BankData: bank.DefaultGenesisState(),
	}

	appState, err = codec.MarshalJSONIndent(app.cdc, genState)
	if err != nil {
		return nil, nil, err
	}

	return appState, validators, err
}

// MakeCodec generates the necessary codecs for Amino
func MakeCodec() *codec.Codec {
	var cdc = codec.New()
	auth.RegisterCodec(cdc)
	bank.RegisterCodec(cdc)
	pylons.RegisterCodec(cdc)
	staking.RegisterCodec(cdc)
	sdk.RegisterCodec(cdc)
	codec.RegisterCrypto(cdc)
	return cdc
}

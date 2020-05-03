package keep

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	codecstd "github.com/cosmos/cosmos-sdk/codec/std"
	"github.com/cosmos/cosmos-sdk/types/module"

	codec "github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/store"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/bank"
	"github.com/cosmos/cosmos-sdk/x/capability"
	"github.com/cosmos/cosmos-sdk/x/crisis"
	distr "github.com/cosmos/cosmos-sdk/x/distribution/types"
	"github.com/cosmos/cosmos-sdk/x/evidence"
	"github.com/cosmos/cosmos-sdk/x/genutil"
	"github.com/cosmos/cosmos-sdk/x/gov"
	"github.com/cosmos/cosmos-sdk/x/ibc"
	transfer "github.com/cosmos/cosmos-sdk/x/ibc/20-transfer"
	"github.com/cosmos/cosmos-sdk/x/mint"
	"github.com/cosmos/cosmos-sdk/x/params"
	"github.com/cosmos/cosmos-sdk/x/slashing"
	"github.com/cosmos/cosmos-sdk/x/staking"
	"github.com/cosmos/cosmos-sdk/x/upgrade"
	abci "github.com/tendermint/tendermint/abci/types"
	"github.com/tendermint/tendermint/libs/log"
	tmtypes "github.com/tendermint/tendermint/types"
	dbm "github.com/tendermint/tm-db"
)

type TestCoinInput struct {
	Cdc  *codec.Codec
	Ctx  sdk.Context
	Ak   auth.AccountKeeper
	Pk   params.Keeper
	Bk   bank.Keeper
	PlnK Keeper
}

func GenItem(cbID string, sender sdk.AccAddress, name string) *types.Item {
	return types.NewItem(
		cbID,
		(types.DoubleInputParamList{types.DoubleInputParam{Key: "endurance", MinValue: "100.00", MaxValue: "500.00"}}).Actualize(),
		(types.LongInputParamList{types.LongInputParam{Key: "HP", MinValue: 100, MaxValue: 500}}).Actualize(),
		(types.StringInputParamList{types.StringInputParam{Key: "Name", Value: name}}).Actualize(),
		sender,
		0,
	)
}
func createTestCodec() *codec.Codec {
	cdc := codec.New()
	auth.RegisterCodec(cdc)
	distr.RegisterCodec(cdc)
	sdk.RegisterCodec(cdc)
	codec.RegisterCrypto(cdc)
	return cdc
}

// NewBasicManager is in charge of setting up basic module elemnets
var ModuleBasics = module.NewBasicManager(
	auth.AppModuleBasic{},
	genutil.AppModuleBasic{},
	bank.AppModuleBasic{},
	capability.AppModuleBasic{},
	staking.AppModuleBasic{},
	mint.AppModuleBasic{},
	params.AppModuleBasic{},
	crisis.AppModuleBasic{},
	slashing.AppModuleBasic{},
	ibc.AppModuleBasic{},
	upgrade.AppModuleBasic{},
	evidence.AppModuleBasic{},
	transfer.AppModuleBasic{},
)

var maccPerms = map[string][]string{
	auth.FeeCollectorName:           nil,
	distr.ModuleName:                nil,
	mint.ModuleName:                 {auth.Minter},
	staking.BondedPoolName:          {auth.Burner, auth.Staking},
	staking.NotBondedPoolName:       {auth.Burner, auth.Staking},
	gov.ModuleName:                  {auth.Burner},
	transfer.GetModuleAccountName(): {auth.Minter, auth.Burner},
}

func SetupTestCoinInput() TestCoinInput {
	// parts from https://github.com/cosmos/cosmos-sdk/blob/release/v0.38.3/x/staking/keeper/test_common.go
	cdc := codecstd.MakeCodec(ModuleBasics)
	appCodec := codecstd.NewAppCodec(cdc)
	db := dbm.NewMemDB()

	keyAcc := sdk.NewKVStoreKey(auth.StoreKey)
	authCapKey := sdk.NewKVStoreKey("authCapKey")
	fckCapKey := sdk.NewKVStoreKey("fckCapKey")
	keyParams := sdk.NewKVStoreKey("params")
	tkeyParams := sdk.NewTransientStoreKey("transient_params")

	fcKey := sdk.NewKVStoreKey("fee_collection")
	cbKey := sdk.NewKVStoreKey("pylons")
	rcKey := sdk.NewKVStoreKey("pylons_recipe")
	tdKey := sdk.NewKVStoreKey("pylons_trade")
	itKey := sdk.NewKVStoreKey("pylons_item")
	bankKey := sdk.NewKVStoreKey(bank.StoreKey)
	execKey := sdk.NewKVStoreKey("pylons_execution")

	ms := store.NewCommitMultiStore(db)
	ms.MountStoreWithDB(keyAcc, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(authCapKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(fckCapKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(keyParams, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(fcKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(cbKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(tdKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(rcKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(itKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(execKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(tkeyParams, sdk.StoreTypeTransient, db)
	ms.LoadLatestVersion()

	ms.GetKVStore(cbKey)

	ctx := sdk.NewContext(ms, abci.Header{ChainID: "test-chain-id"}, false, log.NewNopLogger())

	ctx = ctx.WithConsensusParams(
		&abci.ConsensusParams{
			Validator: &abci.ValidatorParams{
				PubKeyTypes: []string{tmtypes.ABCIPubKeyTypeEd25519},
			},
		},
	)

	blacklistedAddrs := make(map[string]bool)
	pk := params.NewKeeper(appCodec, keyParams, tkeyParams)
	accountKeeper := auth.NewAccountKeeper(
		appCodec, // amino codec
		keyAcc,   // target store
		pk.Subspace(auth.DefaultParamspace),
		auth.ProtoBaseAccount, // prototype
		maccPerms,
	)

	bk := bank.NewBaseKeeper(
		appCodec,
		bankKey,
		accountKeeper,
		pk.Subspace(bank.DefaultParamspace),
		blacklistedAddrs,
	)

	accountKeeper.SetParams(ctx, auth.DefaultParams())

	plnK := NewKeeper(
		bk,
		cbKey,   // cookbook
		rcKey,   // recipe
		itKey,   // item
		execKey, // exec
		tdKey,
		cdc,
	)

	return TestCoinInput{Cdc: cdc, Ctx: ctx, Ak: accountKeeper, Pk: pk, Bk: bk, PlnK: plnK}
}

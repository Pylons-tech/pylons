package keeper

import (
	"testing"

	authkeeper "github.com/cosmos/cosmos-sdk/x/auth/keeper"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	paramskeeper "github.com/cosmos/cosmos-sdk/x/params/keeper"
	paramstypes "github.com/cosmos/cosmos-sdk/x/params/types"

	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"

	"github.com/cosmos/cosmos-sdk/codec"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	"github.com/cosmos/cosmos-sdk/store"
	storetypes "github.com/cosmos/cosmos-sdk/store/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"github.com/tendermint/tendermint/libs/log"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"
	tmdb "github.com/tendermint/tm-db"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var (
	// module account permissions
	maccPerms = map[string][]string{
		authtypes.FeeCollectorName:   nil,
		types.PylonsFeeCollectorName: nil,
		types.PylonsCoinsLockerName:  nil,
		types.PylonsItemsLockerName:  nil,
	}
)

// ModuleAccountAddrs returns all the app's module account addresses.
func ModuleAccountAddrs() map[string]bool {
	modAccAddrs := make(map[string]bool)
	for acc := range maccPerms {
		modAccAddrs[authtypes.NewModuleAddress(acc).String()] = true
	}

	return modAccAddrs
}

// initParamsKeeper init params keeper and its subspaces
func initParamsKeeper(appCodec codec.BinaryMarshaler, legacyAmino *codec.LegacyAmino, key, tkey sdk.StoreKey) paramskeeper.Keeper {
	paramsKeeper := paramskeeper.NewKeeper(appCodec, legacyAmino, key, tkey)

	paramsKeeper.Subspace(authtypes.ModuleName)
	paramsKeeper.Subspace(banktypes.ModuleName)
	paramsKeeper.Subspace(types.ModuleName)

	return paramsKeeper
}

func GetSubspace(paramsKeeper paramskeeper.Keeper, moduleName string) paramstypes.Subspace {
	subspace, _ := paramsKeeper.GetSubspace(moduleName)
	return subspace
}

func setupKeeper(t testing.TB) (Keeper, sdk.Context) {
	storeKeys := sdk.NewKVStoreKeys(
		authtypes.StoreKey, banktypes.StoreKey,
		types.StoreKey,
	)
	tkeys := sdk.NewTransientStoreKeys(paramstypes.TStoreKey)
	memStoreKey := storetypes.NewMemoryStoreKey(types.MemStoreKey)

	db := tmdb.NewMemDB()
	stateStore := store.NewCommitMultiStore(db)
	stateStore.MountStoreWithDB(storeKeys[types.StoreKey], sdk.StoreTypeIAVL, db)
	stateStore.MountStoreWithDB(storeKeys[authtypes.StoreKey], sdk.StoreTypeIAVL, db)
	stateStore.MountStoreWithDB(storeKeys[banktypes.StoreKey], sdk.StoreTypeIAVL, db)
	stateStore.MountStoreWithDB(memStoreKey, sdk.StoreTypeMemory, nil)
	require.NoError(t, stateStore.LoadLatestVersion())

	registry := codectypes.NewInterfaceRegistry()
	appCodec := codec.NewProtoCodec(registry)
	paramsKeeper := initParamsKeeper(appCodec, codec.NewLegacyAmino(), storeKeys[paramstypes.StoreKey], tkeys[paramstypes.TStoreKey])
	accountKeeper := authkeeper.NewAccountKeeper(
		appCodec, storeKeys[authtypes.StoreKey], GetSubspace(paramsKeeper, authtypes.ModuleName), authtypes.ProtoBaseAccount, maccPerms,
	)
	bankKeeper := bankkeeper.NewBaseKeeper(
		appCodec, storeKeys[banktypes.StoreKey], accountKeeper, GetSubspace(paramsKeeper, banktypes.ModuleName), ModuleAccountAddrs(),
	)
	keeper := NewKeeper(
		appCodec,
		storeKeys[types.StoreKey],
		memStoreKey,
		bankKeeper,
		accountKeeper,
		GetSubspace(paramsKeeper, types.ModuleName),
	)

	ctx := sdk.NewContext(stateStore, tmproto.Header{}, false, log.NewNopLogger())
	return keeper, ctx
}

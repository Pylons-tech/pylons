package keeper_test

import (
	"strconv"
	"testing"

	"github.com/cosmos/cosmos-sdk/baseapp"

	"github.com/Pylons-tech/pylons/app"

	"github.com/cosmos/cosmos-sdk/simapp"
	"github.com/stretchr/testify/suite"

	pylonsSimapp "github.com/Pylons-tech/pylons/testutil/simapp"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

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

const (
	// original address: "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	validBech32AccAddr = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337" // nolint: deadcode
	baseAccAddrBech32  = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt33"
)

// CreateTestFakeAddressList creates a list of addresses from baseAccAddrBech32.
// Note, they are not valid Bech32 addresses (except the 7th element), so Bech32 decoding on these will fail
func CreateTestFakeAddressList(numAccount uint) []string {
	accounts := make([]string, numAccount)
	for i := uint(0); i < numAccount; i++ {
		addr := baseAccAddrBech32 + strconv.Itoa(int(i))
		accounts[i] = addr
	}

	return accounts
}

type IntegrationTestSuite struct {
	suite.Suite

	app         *app.App
	ctx         sdk.Context
	queryClient types.QueryClient
	k           keeper.Keeper
}

var (
	// module account permissions
	maccPerms = map[string][]string{
		authtypes.FeeCollectorName: nil,
		types.FeeCollectorName:     nil,
		types.TradesLockerName:     nil,
		types.ExecutionsLockerName: nil,
	}
)

func (suite *IntegrationTestSuite) initKeepersWithPerms() keeper.Keeper {
	app := suite.app
	appCodec := simapp.MakeTestEncodingConfig().Marshaler

	maccPerms := simapp.GetMaccPerms()
	maccPerms[authtypes.FeeCollectorName] = nil
	maccPerms[types.FeeCollectorName] = nil
	maccPerms[types.TradesLockerName] = nil
	maccPerms[types.ExecutionsLockerName] = nil

	pylonsKeeper := keeper.NewKeeper(
		appCodec, app.GetKey(types.StoreKey), app.GetKey(types.MemStoreKey),
		app.BankKeeper, app.AccountKeeper, app.GetSubspace(types.ModuleName),
	)

	return pylonsKeeper
}

func (suite *IntegrationTestSuite) SetupTest() {
	cmdApp := pylonsSimapp.New("./")

	var a *app.App
	switch cmdApp.(type) {
	case *app.App:
		a = cmdApp.(*app.App)
	default:
		panic("imported simApp incorrectly")
	}

	ctx := a.BaseApp.NewContext(false, tmproto.Header{})

	a.PylonsKeeper.SetParams(ctx, types.DefaultParams())

	queryHelper := baseapp.NewQueryServerTestHelper(ctx, a.InterfaceRegistry())
	types.RegisterQueryServer(queryHelper, a.PylonsKeeper)
	queryClient := types.NewQueryClient(queryHelper)

	suite.app = a
	suite.ctx = ctx
	suite.queryClient = queryClient
	suite.k = a.PylonsKeeper

}

func TestKeeperTestSuite(t *testing.T) {
	suite.Run(t, new(IntegrationTestSuite))
}

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
	paramsKeeper.Subspace(types.ModuleName).WithKeyTable(types.ParamKeyTable())

	return paramsKeeper
}

func GetSubspace(paramsKeeper paramskeeper.Keeper, moduleName string) paramstypes.Subspace {
	subspace, found := paramsKeeper.GetSubspace(moduleName)
	if !found {
		panic("Params Keeper not properly set up")
	}

	return subspace
}

func setupKeeper(t testing.TB) (keeper.Keeper, sdk.Context) {
	storeKeys := sdk.NewKVStoreKeys(
		authtypes.StoreKey, banktypes.StoreKey,
		types.StoreKey, paramstypes.StoreKey,
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
	k := keeper.NewKeeper(
		appCodec,
		storeKeys[types.StoreKey],
		memStoreKey,
		bankKeeper,
		accountKeeper,
		GetSubspace(paramsKeeper, types.ModuleName),
	)

	ctx := sdk.NewContext(stateStore, tmproto.Header{}, false, log.NewNopLogger())

	// init genesis to set initial state of the params modules
	k.SetParams(ctx, types.DefaultParams())
	return k, ctx
}

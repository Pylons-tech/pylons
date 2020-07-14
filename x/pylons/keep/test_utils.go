package keep

import (
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	codec "github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/store"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/bank"
	distr "github.com/cosmos/cosmos-sdk/x/distribution/types"
	"github.com/cosmos/cosmos-sdk/x/params"
	sttypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	"github.com/cosmos/cosmos-sdk/x/supply"
	"github.com/stretchr/testify/require"
	abci "github.com/tendermint/tendermint/abci/types"
	"github.com/tendermint/tendermint/libs/log"
	tmtypes "github.com/tendermint/tendermint/types"
	dbm "github.com/tendermint/tm-db"
)

// TestCoinInput is a struct that hodl mocked chain env
type TestCoinInput struct {
	Cdc  *codec.Codec
	Ctx  sdk.Context
	Ak   auth.AccountKeeper
	Pk   params.Keeper
	Bk   bank.Keeper
	PlnK Keeper
}

// GenItem generate an item with name
func GenItem(cbID string, sender sdk.AccAddress, name string) *types.Item {
	return types.NewItem(
		cbID,
		(types.DoubleInputParamList{types.DoubleInputParam{Key: "endurance", MinValue: "100.00", MaxValue: "500.00"}}).Actualize(),
		(types.LongInputParamList{types.LongInputParam{Key: "HP", MinValue: 100, MaxValue: 500}}).Actualize(),
		(types.StringInputParamList{types.StringInputParam{Key: "Name", Value: name}}).Actualize(),
		sender,
		0,
		0,
	)
}
func createTestCodec() *codec.Codec {
	cdc := codec.New()
	auth.RegisterCodec(cdc)
	distr.RegisterCodec(cdc)
	supply.RegisterCodec(cdc)
	sdk.RegisterCodec(cdc)
	codec.RegisterCrypto(cdc)
	return cdc
}

// SetupTestCoinInput mock chain env
func SetupTestCoinInput() TestCoinInput {
	// parts from https://github.com/cosmos/cosmos-sdk/blob/release/v0.38.3/x/staking/keeper/test_common.go
	cdc := createTestCodec()
	db := dbm.NewMemDB()

	keyAcc := sdk.NewKVStoreKey(auth.StoreKey)
	authCapKey := sdk.NewKVStoreKey("authCapKey")
	fckCapKey := sdk.NewKVStoreKey("fckCapKey")
	keyParams := sdk.NewKVStoreKey("params")
	keySupply := sdk.NewKVStoreKey(supply.StoreKey)
	tkeyParams := sdk.NewTransientStoreKey("transient_params")

	fcKey := sdk.NewKVStoreKey("fee_collection")
	entKey := sdk.NewKVStoreKey("pylons_entity")
	cbKey := sdk.NewKVStoreKey("pylons_cookbook")
	rcKey := sdk.NewKVStoreKey("pylons_recipe")
	tdKey := sdk.NewKVStoreKey("pylons_trade")
	itKey := sdk.NewKVStoreKey("pylons_item")
	execKey := sdk.NewKVStoreKey("pylons_execution")
	lockedCoinKey := sdk.NewKVStoreKey("pylons_locked_coin")

	ms := store.NewCommitMultiStore(db)
	ms.MountStoreWithDB(keySupply, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(keyAcc, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(authCapKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(fckCapKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(keyParams, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(fcKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(entKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(cbKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(tdKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(rcKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(itKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(execKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(lockedCoinKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(tkeyParams, sdk.StoreTypeTransient, db)
	//nolint:errcheck
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

	feeCollectorAcc := supply.NewEmptyModuleAccount(auth.FeeCollectorName)
	notBondedPool := supply.NewEmptyModuleAccount(sttypes.NotBondedPoolName, supply.Burner, supply.Staking)
	bondPool := supply.NewEmptyModuleAccount(sttypes.BondedPoolName, supply.Burner, supply.Staking)

	blacklistedAddrs := make(map[string]bool)
	blacklistedAddrs[feeCollectorAcc.GetAddress().String()] = true
	blacklistedAddrs[notBondedPool.GetAddress().String()] = true
	blacklistedAddrs[bondPool.GetAddress().String()] = true

	pk := params.NewKeeper(cdc, keyParams, tkeyParams)
	accountKeeper := auth.NewAccountKeeper(
		cdc,    // amino codec
		keyAcc, // target store
		pk.Subspace(auth.DefaultParamspace),
		auth.ProtoBaseAccount, // prototype
	)

	bk := bank.NewBaseKeeper(
		accountKeeper,
		pk.Subspace(bank.DefaultParamspace),
		blacklistedAddrs,
	)

	accountKeeper.SetParams(ctx, auth.DefaultParams())

	plnK := NewKeeper(
		bk,
		entKey,  // entity
		cbKey,   // cookbook
		rcKey,   // recipe
		itKey,   // item
		execKey, // exec
		tdKey,
		lockedCoinKey,
		cdc,
	)

	return TestCoinInput{Cdc: cdc, Ctx: ctx, Ak: accountKeeper, Pk: pk, Bk: bk, PlnK: plnK}
}

// SetupTestAccounts do setup for test accounts with coins
func SetupTestAccounts(t *testing.T, tci TestCoinInput, s1coins sdk.Coins, s2coins sdk.Coins, s3coins sdk.Coins, s4coins sdk.Coins) (sdk.AccAddress, sdk.AccAddress, sdk.AccAddress, sdk.AccAddress) {
	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")
	sender3, _ := sdk.AccAddressFromBech32("cosmos17aspkwytc3j5a3zhzdh20d6m8kc28eed6gdl6t")
	sender4, _ := sdk.AccAddressFromBech32("cosmos13p8890funv54hflk82ju0zv47tspglpk373453")

	if s1coins != nil {
		_, err := tci.Bk.AddCoins(tci.Ctx, sender1, s1coins)
		require.True(t, err == nil)
	}

	if s2coins != nil {
		_, err := tci.Bk.AddCoins(tci.Ctx, sender2, s2coins)
		require.True(t, err == nil)
	}

	if s3coins != nil {
		_, err := tci.Bk.AddCoins(tci.Ctx, sender3, s3coins)
		require.True(t, err == nil)
	}

	if s4coins != nil {
		_, err := tci.Bk.AddCoins(tci.Ctx, sender4, s4coins)
		require.True(t, err == nil)
	}
	return sender1, sender2, sender3, sender4
}

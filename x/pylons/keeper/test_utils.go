package keeper

import (
	"testing"

	"github.com/stretchr/testify/require"
	abcitypes "github.com/tendermint/tendermint/abci/types"
	"github.com/tendermint/tendermint/libs/log"
	abci "github.com/tendermint/tendermint/proto/tendermint/types"
	tmtypes "github.com/tendermint/tendermint/types"
	dbm "github.com/tendermint/tm-db"

	"github.com/cosmos/cosmos-sdk/client"
	codec "github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/store"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authkeeper "github.com/cosmos/cosmos-sdk/x/auth/keeper"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
	distrtypes "github.com/cosmos/cosmos-sdk/x/distribution/types"
	paramskeeper "github.com/cosmos/cosmos-sdk/x/params/keeper"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	sttypes "github.com/cosmos/cosmos-sdk/x/staking/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// TestCoinInput is a struct that hodl mocked chain env
type TestCoinInput struct {
	Cdc      *codec.LegacyAmino
	Ctx      sdk.Context
	TxConfig client.TxConfig
	Ak       authkeeper.AccountKeeper
	Pk       paramskeeper.Keeper
	Bk       bankkeeper.Keeper
	PlnK     Keeper
	PlnH     types.MsgServer
	PlnQ     types.QueryServer
}

// GenItem generate an item with name
func GenItem(cbID string, sender sdk.AccAddress, name string) types.Item {
	return types.NewItem(
		cbID,
		types.DoubleInputParamList{
			{
				Key:      "endurance",
				MinValue: sdk.NewDec(100.00),
				MaxValue: sdk.NewDec(500.00),
			},
		}.Actualize(),
		types.LongInputParamList{
			{
				Key:      "HP",
				MinValue: 100,
				MaxValue: 500,
			},
		}.Actualize(),
		types.StringInputParamList{
			{
				Key:   "Name",
				Value: name,
			},
		}.Actualize(),
		sender,
		0,
		0,
	)
}

var (
	t = types.DoubleInputParamList{
		{
			Key:      "endurance",
			MinValue: sdk.NewDec(100.00),
			MaxValue: sdk.NewDec(500.00),
		},
	}
)

func createTestCodec() *codec.LegacyAmino {
	cdc := codec.NewLegacyAmino()
	authtypes.RegisterLegacyAminoCodec(cdc)
	distrtypes.RegisterLegacyAminoCodec(cdc)
	sdk.RegisterLegacyAminoCodec(cdc)
	codec.RegisterEvidences(cdc)
	return cdc
}

// SetupTestCoinInput mock chain env
func SetupTestCoinInput() TestCoinInput {
	// parts from https://github.com/cosmos/cosmos-sdk/blob/release/v0.38.3/x/staking/keeper/test_common.go
	cdc := MakeEncodingConfig()
	db := dbm.NewMemDB()

	keyAcc := sdk.NewKVStoreKey(authtypes.StoreKey)
	keyParams := sdk.NewKVStoreKey("params")
	tkeyParams := sdk.NewTransientStoreKey("transient_params")

	stringKeys := []string{
		"authCapKey",
		"fckCapKey",
		"fee_collection",
		banktypes.StoreKey,
	}
	stringKeys = append(stringKeys, StoreKeyList...)

	keys := sdk.NewKVStoreKeys(stringKeys...)

	ms := store.NewCommitMultiStore(db)
	ms.MountStoreWithDB(keyAcc, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(keyParams, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(tkeyParams, sdk.StoreTypeTransient, db)
	for _, kvsk := range keys {
		ms.MountStoreWithDB(kvsk, sdk.StoreTypeIAVL, db)
	}

	//nolint:errcheck
	ms.LoadLatestVersion()

	ctx := sdk.NewContext(ms, abci.Header{ChainID: "pylons-testnet"}, false, log.NewNopLogger())

	ctx = ctx.WithConsensusParams(
		&abcitypes.ConsensusParams{
			Validator: &abci.ValidatorParams{
				PubKeyTypes: []string{tmtypes.ABCIPubKeyTypeEd25519},
			},
		},
	)

	feeCollectorAcc := authtypes.NewEmptyModuleAccount(authtypes.FeeCollectorName)
	notBondedPool := authtypes.NewEmptyModuleAccount(sttypes.NotBondedPoolName, authtypes.Burner, authtypes.Staking)
	bondPool := authtypes.NewEmptyModuleAccount(sttypes.BondedPoolName, authtypes.Burner, authtypes.Staking)

	blacklistedAddrs := make(map[string]bool)
	blacklistedAddrs[feeCollectorAcc.GetAddress().String()] = true
	blacklistedAddrs[notBondedPool.GetAddress().String()] = true
	blacklistedAddrs[bondPool.GetAddress().String()] = true

	pk := paramskeeper.NewKeeper(cdc.Marshaler, cdc.Amino, keyParams, tkeyParams)
	accountKeeper := authkeeper.NewAccountKeeper(
		cdc.Marshaler, // amino codec
		keyAcc,        // target store
		pk.Subspace(authtypes.ModuleName),
		authtypes.ProtoBaseAccount, // prototype
		map[string][]string{
			authtypes.FeeCollectorName:     nil,
			distrtypes.ModuleName:          nil,
			stakingtypes.BondedPoolName:    {authtypes.Burner, authtypes.Staking},
			stakingtypes.NotBondedPoolName: {authtypes.Burner, authtypes.Staking},
		},
	)

	bk := bankkeeper.NewBaseKeeper(
		cdc.Marshaler,
		keys[banktypes.StoreKey],
		accountKeeper,
		pk.Subspace(banktypes.ModuleName),
		blacklistedAddrs,
	)

	accountKeeper.SetParams(ctx, authtypes.DefaultParams())

	plnK := NewKeeper(
		bk,
		cdc.Amino,
		keys,
	)

	return TestCoinInput{Cdc: cdc.Amino, Ctx: ctx, TxConfig: cdc.TxConfig, Ak: accountKeeper, Pk: pk, Bk: bk, PlnK: plnK, PlnH: nil}
}

// SetupTestAccounts do setup for test accounts with coins
func SetupTestAccounts(t *testing.T, tci TestCoinInput, s1coins sdk.Coins, s2coins sdk.Coins, s3coins sdk.Coins, s4coins sdk.Coins) (sdk.AccAddress, sdk.AccAddress, sdk.AccAddress, sdk.AccAddress) {
	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")
	sender3, _ := sdk.AccAddressFromBech32("cosmos17aspkwytc3j5a3zhzdh20d6m8kc28eed6gdl6t")
	sender4, _ := sdk.AccAddressFromBech32("cosmos13p8890funv54hflk82ju0zv47tspglpk373453")

	if s1coins != nil {
		err := tci.Bk.AddCoins(tci.Ctx, sender1, s1coins.Sort())
		require.True(t, err == nil, err)
	}

	if s2coins != nil {
		err := tci.Bk.AddCoins(tci.Ctx, sender2, s2coins.Sort())
		require.True(t, err == nil, err)
	}

	if s3coins != nil {
		err := tci.Bk.AddCoins(tci.Ctx, sender3, s3coins.Sort())
		require.True(t, err == nil, err)
	}

	if s4coins != nil {
		err := tci.Bk.AddCoins(tci.Ctx, sender4, s4coins.Sort())
		require.True(t, err == nil, err)
	}
	return sender1, sender2, sender3, sender4
}

package keep

import (
	abci "github.com/tendermint/tendermint/abci/types"
	dbm "github.com/tendermint/tendermint/libs/db"
	"github.com/tendermint/tendermint/libs/log"

	codec "github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/store"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/bank"
	"github.com/cosmos/cosmos-sdk/x/params"

	"github.com/MikeSofaer/pylons/x/pylons/types"
)

type TestCoinInput struct {
	Cdc  *codec.Codec
	Ctx  sdk.Context
	Ak   auth.AccountKeeper
	Pk   params.Keeper
	Bk   bank.Keeper
	FcK  auth.FeeCollectionKeeper
	PlnK Keeper
}

func GenItem(cbID string, sender sdk.AccAddress, name string) *types.Item {
	return types.NewItem(
		cbID,
		(types.DoubleInputParamList{types.DoubleInputParam{Key: "endurance", MinValue: "100.00", MaxValue: "500.00"}}).Actualize(),
		(types.LongInputParamList{types.LongInputParam{Key: "HP", MinValue: 100, MaxValue: 500}}).Actualize(),
		(types.StringInputParamList{types.StringInputParam{Key: "Name", Value: name}}).Actualize(),
		sender,
	)
}

// This is used by integration tests when going to manage by GUIDs rather than managing by name
func GenItemWithGUID(GUID string, cbID string, sender sdk.AccAddress, name string) *types.Item {
	return types.NewItemWithGUID(
		GUID,
		cbID,
		(types.DoubleInputParamList{types.DoubleInputParam{Key: "endurance", MinValue: "100.00", MaxValue: "500.00"}}).Actualize(),
		(types.LongInputParamList{types.LongInputParam{Key: "HP", MinValue: 100, MaxValue: 500}}).Actualize(),
		(types.StringInputParamList{types.StringInputParam{Key: "Name", Value: name}}).Actualize(),
		sender,
	)
}

func SetupTestCoinInput() TestCoinInput {
	db := dbm.NewMemDB()

	cdc := codec.New()
	auth.RegisterBaseAccount(cdc)

	authCapKey := sdk.NewKVStoreKey("authCapKey")
	fckCapKey := sdk.NewKVStoreKey("fckCapKey")
	keyParams := sdk.NewKVStoreKey("params")
	tkeyParams := sdk.NewTransientStoreKey("transient_params")

	fcKey := sdk.NewKVStoreKey("fee_collection")
	cbKey := sdk.NewKVStoreKey("pylons")
	rcKey := sdk.NewKVStoreKey("pylons_recipe")
	tdKey := sdk.NewKVStoreKey("pylons_trade")
	itKey := sdk.NewKVStoreKey("pylons_item")
	execKey := sdk.NewKVStoreKey("pylons_execution")

	ms := store.NewCommitMultiStore(db)
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

	pk := params.NewKeeper(cdc, keyParams, tkeyParams)
	ak := auth.NewAccountKeeper(
		cdc, authCapKey, pk.Subspace(auth.DefaultParamspace), auth.ProtoBaseAccount,
	)
	ctx := sdk.NewContext(ms, abci.Header{ChainID: "test-chain-id"}, false, log.NewNopLogger())

	ak.SetParams(ctx, auth.DefaultParams())

	bk := bank.NewBaseKeeper(
		ak,
		pk.Subspace(bank.DefaultParamspace),
		bank.DefaultCodespace,
	)

	fcK := auth.NewFeeCollectionKeeper(cdc, fcKey)

	plnK := NewKeeper(
		bk,
		cbKey,   // cookbook
		rcKey,   // recipe
		itKey,   // item
		execKey, // exec
		tdKey,
		cdc,
	)

	return TestCoinInput{Cdc: cdc, Ctx: ctx, Ak: ak, Pk: pk, Bk: bk, FcK: fcK, PlnK: plnK}
}

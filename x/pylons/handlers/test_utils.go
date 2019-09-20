package handlers

import (
	"encoding/json"

	abci "github.com/tendermint/tendermint/abci/types"
	dbm "github.com/tendermint/tendermint/libs/db"
	"github.com/tendermint/tendermint/libs/log"

	codec "github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/store"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/bank"
	"github.com/cosmos/cosmos-sdk/x/params"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
)

type TestCoinInput struct {
	cdc  *codec.Codec
	ctx  sdk.Context
	ak   auth.AccountKeeper
	pk   params.Keeper
	bk   bank.Keeper
	fcK  auth.FeeCollectionKeeper
	plnK keep.Keeper
}

func mockCookbook(tci TestCoinInput, sender sdk.AccAddress) CreateCBResponse {
	cookbookName := "cookbook-00001"
	cookbookDesc := "this has to meet character limits"
	msg := msgs.NewMsgCreateCookbook(cookbookName, cookbookDesc, "SketchyCo", "1.0.0", "example@example.com", 1, sender)
	cbResult := HandlerMsgCreateCookbook(tci.ctx, tci.plnK, msg)
	cbData := CreateCBResponse{}
	json.Unmarshal(cbResult.Data, &cbData)
	return cbData
}

func setupTestCoinInput() TestCoinInput {
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
	itKey := sdk.NewKVStoreKey("pylons_item")
	execKey := sdk.NewKVStoreKey("pylons_execution")

	ms := store.NewCommitMultiStore(db)
	ms.MountStoreWithDB(authCapKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(fckCapKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(keyParams, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(fcKey, sdk.StoreTypeIAVL, db)
	ms.MountStoreWithDB(cbKey, sdk.StoreTypeIAVL, db)
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

	plnK := keep.NewKeeper(
		bk,
		cbKey,   // cookbook
		rcKey,   // recipe
		itKey,   // item
		execKey, // exec
		cdc,
	)

	return TestCoinInput{cdc: cdc, ctx: ctx, ak: ak, pk: pk, bk: bk, fcK: fcK, plnK: plnK}
}

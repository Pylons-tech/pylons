package keeper

import (
	"fmt"

	"github.com/tendermint/tendermint/libs/log"

	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	// this line is used by starport scaffolding # ibc/keeper/import
)

type (
	Keeper struct {
		cdc           codec.Marshaler
		storeKey      sdk.StoreKey
		memKey        sdk.StoreKey
		bankKeeper    types.BankKeeper
		accountKeeper types.AccountKeeper
		// this line is used by starport scaffolding # ibc/keeper/attribute

	}
)

func NewKeeper(
	cdc codec.Marshaler,
	storeKey,
	memKey sdk.StoreKey,
	bk types.BankKeeper,
	ak types.AccountKeeper,
	// this line is used by starport scaffolding # ibc/keeper/parameter

) Keeper {

	// ensure pylons module accounts are set
	if addr := ak.GetModuleAddress(types.PylonsFeeCollectorName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", types.PylonsFeeCollectorName))
	}
	if addr := ak.GetModuleAddress(types.PylonsCoinsLockerName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", types.PylonsCoinsLockerName))
	}
	if addr := ak.GetModuleAddress(types.PylonsItemsLockerName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", types.PylonsItemsLockerName))
	}

	return Keeper{
		cdc:           cdc,
		storeKey:      storeKey,
		memKey:        memKey,
		bankKeeper:    bk,
		accountKeeper: ak,
		// this line is used by starport scaffolding # ibc/keeper/return

	}
}

func (k Keeper) Logger(ctx sdk.Context) log.Logger {
	return ctx.Logger().With("module", fmt.Sprintf("x/%s", types.ModuleName))
}

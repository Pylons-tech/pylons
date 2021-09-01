package keeper

import (
	"fmt"

	paramtypes "github.com/cosmos/cosmos-sdk/x/params/types"

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
		paramSpace    paramtypes.Subspace
		// this line is used by starport scaffolding # ibc/keeper/attribute

	}
)

func NewKeeper(
	cdc codec.Marshaler,
	storeKey,
	memKey sdk.StoreKey,
	bk types.BankKeeper,
	ak types.AccountKeeper,
	paramSpace paramtypes.Subspace,
	// this line is used by starport scaffolding # ibc/keeper/parameter

) Keeper {

	// ensure pylons module accounts are set
	if addr := ak.GetModuleAddress(types.FeeCollectorName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", types.FeeCollectorName))
	}
	if addr := ak.GetModuleAddress(types.TradesLockerName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", types.TradesLockerName))
	}
	if addr := ak.GetModuleAddress(types.ExecutionsLockerName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", types.ExecutionsLockerName))
	}

	if addr := ak.GetModuleAddress(types.CoinsIssuerName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", types.CoinsIssuerName))
	}

	// set KeyTable if it has not already been set
	if !paramSpace.HasKeyTable() {
		paramSpace = paramSpace.WithKeyTable(types.ParamKeyTable())
	}

	return Keeper{
		cdc:           cdc,
		storeKey:      storeKey,
		memKey:        memKey,
		bankKeeper:    bk,
		accountKeeper: ak,
		paramSpace:    paramSpace,
		// this line is used by starport scaffolding # ibc/keeper/return

	}
}

func (k Keeper) Logger(ctx sdk.Context) log.Logger {
	return ctx.Logger().With("module", fmt.Sprintf("x/%s", types.ModuleName))
}

func (k Keeper) FeeCollectorAddress() sdk.AccAddress {
	return k.accountKeeper.GetModuleAddress(types.FeeCollectorName)
}

func (k Keeper) TradesLockerAddress() sdk.AccAddress {
	return k.accountKeeper.GetModuleAddress(types.TradesLockerName)
}

func (k Keeper) ExecutionsLockerAddress() sdk.AccAddress {
	return k.accountKeeper.GetModuleAddress(types.ExecutionsLockerName)
}

func (k Keeper) CoinsIssuerAddress() sdk.AccAddress {
	return k.accountKeeper.GetModuleAddress(types.CoinsIssuerName)
}

package keeper

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	storetypes "github.com/cosmos/cosmos-sdk/store/types"
	paramtypes "github.com/cosmos/cosmos-sdk/x/params/types"

	"github.com/tendermint/tendermint/libs/log"

	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type (
	Keeper struct {
		cdc            codec.Codec
		storeKey       storetypes.StoreKey
		memKey         storetypes.StoreKey
		bankKeeper     v1beta1.BankKeeper
		accountKeeper  v1beta1.AccountKeeper
		transferKeeper v1beta1.TransferKeeper
		paramSpace     paramtypes.Subspace
	}
)

func NewKeeper(
	cdc codec.Codec,
	storeKey,
	memKey storetypes.StoreKey,
	bk v1beta1.BankKeeper,
	ak v1beta1.AccountKeeper,
	tk v1beta1.TransferKeeper,
	paramSpace paramtypes.Subspace,
) Keeper {
	// ensure pylons module accounts are set
	if addr := ak.GetModuleAddress(v1beta1.FeeCollectorName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", v1beta1.FeeCollectorName))
	}
	if addr := ak.GetModuleAddress(v1beta1.TradesLockerName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", v1beta1.TradesLockerName))
	}
	if addr := ak.GetModuleAddress(v1beta1.ExecutionsLockerName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", v1beta1.ExecutionsLockerName))
	}

	if addr := ak.GetModuleAddress(v1beta1.CoinsIssuerName); addr == nil {
		panic(fmt.Sprintf("%s module account has not been set", v1beta1.CoinsIssuerName))
	}

	// set KeyTable if it has not already been set
	if !paramSpace.HasKeyTable() {
		paramSpace = paramSpace.WithKeyTable(v1beta1.ParamKeyTable())
	}

	return Keeper{
		cdc:            cdc,
		storeKey:       storeKey,
		memKey:         memKey,
		bankKeeper:     bk,
		accountKeeper:  ak,
		transferKeeper: tk,
		paramSpace:     paramSpace,
	}
}

func (k Keeper) Logger(ctx sdk.Context) log.Logger {
	return ctx.Logger().With("module", fmt.Sprintf("x/%s", v1beta1.ModuleName))
}

func (k Keeper) FeeCollectorAddress() sdk.AccAddress {
	return k.accountKeeper.GetModuleAddress(v1beta1.FeeCollectorName)
}

func (k Keeper) TradesLockerAddress() sdk.AccAddress {
	return k.accountKeeper.GetModuleAddress(v1beta1.TradesLockerName)
}

func (k Keeper) ExecutionsLockerAddress() sdk.AccAddress {
	return k.accountKeeper.GetModuleAddress(v1beta1.ExecutionsLockerName)
}

func (k Keeper) CoinsIssuerAddress() sdk.AccAddress {
	return k.accountKeeper.GetModuleAddress(v1beta1.CoinsIssuerName)
}

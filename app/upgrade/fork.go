package upgrade

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	stakingkeeper "github.com/cosmos/cosmos-sdk/x/staking/keeper"
	upgradetypes "github.com/cosmos/cosmos-sdk/x/upgrade/types"
	"github.com/cosmos/cosmos-sdk/codec"
	storetypes "github.com/cosmos/cosmos-sdk/store/types"
	v046 "github.com/Pylons-tech/pylons/x/pylons/migrations/v046"
)

// CreateUpgradeHandler make upgrade handler
func CreateUpgradeHandler(mm *module.Manager, configurator module.Configurator, staking *stakingkeeper.Keeper, pylonStoreKey storetypes.StoreKey, cdc codec.Codec) upgradetypes.UpgradeHandler {
	return func(ctx sdk.Context, plan upgradetypes.Plan, vm module.VersionMap) (module.VersionMap, error) {
		newVM, err := mm.RunMigrations(ctx, configurator, vm)
		if err != nil {
			return newVM, err
		}
		FixMinCommisionRate(ctx, staking)
		MigrateStore(ctx, pylonStoreKey, cdc)

		// override here
		return newVM, err
	}
}

// Fixes an error where validators can be created with a commission rate
// less than the network minimum rate.
func FixMinCommisionRate(ctx sdk.Context, staking *stakingkeeper.Keeper) {
	// Upgrade every validators min-commission rate
	validators := staking.GetAllValidators(ctx)
	minCommissionRate := staking.GetParams(ctx).MinCommissionRate
	for _, v := range validators {
		if v.Commission.Rate.LT(minCommissionRate) {
			comm, err := staking.UpdateValidatorCommission(
				ctx, v, minCommissionRate)
			if err != nil {
				panic(err)
			}
			v.Commission = comm

			// call the before-modification hook since we're about to update the commission
			err = staking.BeforeValidatorModified(ctx, v.GetOperator())
			if err != nil {
				panic(err)
			}

			staking.SetValidator(ctx, v)
		}
	}
}

func MigrateStore(ctx sdk.Context, storeKey storetypes.StoreKey, cdc codec.Codec) error {
	return v046.MigrateStore(ctx, storeKey, cdc)
}
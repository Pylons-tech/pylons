package v4

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	bankKeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	upgrade_types "github.com/cosmos/cosmos-sdk/x/upgrade/types"
	// "github.com/cosmos/iavl/internal/logger"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CreateUpgradeHandler(
	mm *module.Manager,
	configurator module.Configurator,
	bankKeeper bankKeeper.Keeper,
) upgrade_types.UpgradeHandler {
	return func(ctx sdk.Context, plan upgrade_types.Plan, fromVM module.VersionMap) (module.VersionMap, error) {
		// logger := ctx.Logger()

		if types.IsMainnet(ctx.ChainID()) {
			// TODO: Logic upgadeHandler
		}
		return mm.RunMigrations(ctx, configurator, fromVM)
	}
}

// TODO: Function helper for upgradeHandler

package v2

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	bankKeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	upgradetypes "github.com/cosmos/cosmos-sdk/x/upgrade/types"
	// "github.com/cosmos/iavl/internal/logger"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CreateUpgradeHandler(
	mm *module.Manager,
	configurator module.Configurator,
	bankKeeper bankKeeper.Keeper,
) upgradetypes.UpgradeHandler {
	return func(ctx sdk.Context, plan upgradetypes.Plan, fromVM module.VersionMap) (module.VersionMap, error) {
		// logger := ctx.Logger()

		if types.IsMainnet(ctx.ChainID()) {
			// Logic upgadeHandler
		}
		return mm.RunMigrations(ctx, configurator, fromVM)
	}
}

// TODO: Function helper for upgradeHandler

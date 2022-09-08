package epochs

import (
	"time"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/epochs/keeper"
	"github.com/Pylons-tech/pylons/x/epochs/types"
)

// InitGenesis initializes the capability module's state from a provided genesis
// state.
func InitGenesis(ctx sdk.Context, k keeper.Keeper, genState types.GenesisState) {
	// this line is used by starport scaffolding # genesis/module/init

	// set epoch info from genesis
	for _, epoch := range genState.Epochs {
		// when epoch counting start time is not set, set it
		if epoch.StartTime.Equal(time.Time{}) {
			epoch.StartTime = ctx.BlockTime()
		}

		k.SetEpochInfo(ctx, epoch)
	}
}

// ExportGenesis returns the capability module's exported genesis.
func ExportGenesis(ctx sdk.Context, k keeper.Keeper) *types.GenesisState {
	genesis := types.DefaultGenesis()

	// this line is used by starport scaffolding # genesis/module/export
	genesis.Epochs = k.AllEpochInfos(ctx)

	return genesis
}

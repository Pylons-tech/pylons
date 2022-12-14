package v7

import (
	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	authkeeper "github.com/cosmos/cosmos-sdk/x/auth/keeper"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	stakingkeeper "github.com/cosmos/cosmos-sdk/x/staking/keeper"
	upgradetypes "github.com/cosmos/cosmos-sdk/x/upgrade/types"
)

func CreateUpgradeHandler(
	mm *module.Manager,
	configurator module.Configurator,
	bankKeeper bankkeeper.Keeper,
	accKeeper *authkeeper.AccountKeeper,
	staking *stakingkeeper.Keeper,
) upgradetypes.UpgradeHandler {
	return func(ctx sdk.Context, plan upgradetypes.Plan, fromVM module.VersionMap) (module.VersionMap, error) {
		// logger := ctx.Logger()

		bankBaseKeeper, _ := bankKeeper.(bankkeeper.BaseKeeper)
		if types.IsMainnet(ctx.ChainID()) {
			BurnToken(ctx, accKeeper, &bankBaseKeeper, staking)
		}

		vm, err := mm.RunMigrations(ctx, configurator, fromVM)
		return vm, err
	}
}

// Burn bedrock denom token
func BurnToken(ctx sdk.Context, accKeeper *authkeeper.AccountKeeper, bank *bankkeeper.BaseKeeper, staking *stakingkeeper.Keeper) {
	// only burn bedrock token
	denom := types.StakingCoinDenom
	// Get all account balances
	accs := bank.GetAccountsBalances(ctx)
	for _, acc := range accs {
		balance := acc.Coins.AmountOf(denom)
		// Check if denom token amount GT 0
		if balance.GT(math.ZeroInt()) {
			amount := sdk.NewCoin(denom, balance)
			// Send denom token to module
			err := bank.SendCoinsFromAccountToModule(ctx, sdk.MustAccAddressFromBech32(acc.Address), types.PaymentsProcessorName, sdk.NewCoins(amount))
			if err != nil {
				panic(err)
			}
			// Burn denom token in module
			err = bank.BurnCoins(ctx, types.PaymentsProcessorName, sdk.NewCoins(amount))
			if err != nil {
				panic(err)
			}
		}
	}
}

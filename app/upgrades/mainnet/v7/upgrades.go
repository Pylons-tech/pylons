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

const (
	// mainnet master wallet address
	MasterWallet = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	MaxSupply    = 1_000_000_000_000_000
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
	// Get all delegations
	delegations := staking.GetAllDelegations(ctx)
	// Get all account balances
	accs := bank.GetAccountsBalances(ctx)
	for _, acc := range accs {
		found := false
		balance := acc.Coins.AmountOf(denom)
		// Check if denom token amount GT 0
		if balance.GT(math.ZeroInt()) {
			for _, delegator := range delegations {
				// Check if account address is equal to delegator address, if equal do nothing
				if acc.Address == delegator.DelegatorAddress || acc.Address == MasterWallet {
					found = true
					break
				} else {
					// If account address address is not equal to delegator address burn token
					found = false
				}
			}
			if !found {
				amount := sdk.NewCoin(denom, balance)
				BurnCoins(ctx, bank, acc.Address, amount)
			}
		}
	}

	supply := bank.GetSupply(ctx, denom)
	maxSupply := math.NewInt(MaxSupply)
	if supply.Amount.GT(maxSupply) {

		extraSupply := supply.Amount.Sub(maxSupply)
		extraCoins := sdk.NewCoin(denom, extraSupply)
		BurnCoins(ctx, bank, MasterWallet, extraCoins)

	}

}

func BurnCoins(ctx sdk.Context, bank *bankkeeper.BaseKeeper, acc string, amount sdk.Coin) {
	// Send denom token to module
	err := bank.SendCoinsFromAccountToModule(ctx, sdk.MustAccAddressFromBech32(acc), types.PaymentsProcessorName, sdk.NewCoins(amount))
	if err != nil {
		panic(err)
	}
	// Burn denom token in module
	err = bank.BurnCoins(ctx, types.PaymentsProcessorName, sdk.NewCoins(amount))
	if err != nil {
		panic(err)
	}

}

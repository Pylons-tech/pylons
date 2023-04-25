package v5

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
	// Master Wallet address
	MasterWallet = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
)

var (
	TotalUbedrock       = math.NewIntFromUint64(1e15) // 1 bedrock = 1_000_000 ubedrock
	MasterWalletbalance = math.NewIntFromUint64(1e15)
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

		if types.IsMainnet(ctx.ChainID()) {
			MintUbedrockForInitialAccount(ctx, &bankBaseKeeper, staking)
		}

		return vm, err
	}
}

// Burn stripeUSD denom token
func BurnToken(ctx sdk.Context, _ *authkeeper.AccountKeeper, bank *bankkeeper.BaseKeeper, _ *stakingkeeper.Keeper) {
	// only burn stripe usd token
	denom := types.StripeCoinDenom
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

// Mint ubedrock for master wallet
func MintUbedrockForInitialAccount(ctx sdk.Context, bank *bankkeeper.BaseKeeper, _ *stakingkeeper.Keeper) {
	// Get currect balance of master wallet address
	balance := bank.GetBalance(ctx, sdk.MustAccAddressFromBech32(MasterWallet), types.StakingCoinDenom)
	// check difference in amount to add
	toAdd := MasterWalletbalance.Sub(balance.Amount)

	// Mint coin for module
	err := bank.MintCoins(ctx, types.PaymentsProcessorName, sdk.NewCoins(sdk.NewCoin(types.StakingCoinDenom, toAdd)))
	if err != nil {
		panic(err)
	}
	// Send coin required to meet master wallet balance from module to account
	err = bank.SendCoinsFromModuleToAccount(
		ctx,
		types.PaymentsProcessorName,
		sdk.MustAccAddressFromBech32(MasterWallet),
		sdk.NewCoins(sdk.NewCoin(types.StakingCoinDenom, toAdd)),
	)
	if err != nil {
		panic(err)
	}
}

package v4

import (
	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	authkeeper "github.com/cosmos/cosmos-sdk/x/auth/keeper"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	stakingkeeper "github.com/cosmos/cosmos-sdk/x/staking/keeper"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	upgradetypes "github.com/cosmos/cosmos-sdk/x/upgrade/types"
)

const (
	//----------- FAKE ADDRESS---------------//
	// StakeholderDistribution wallet address
	StakeholderDistribution = "pylo1csclcc6rzs7z3eyjqvzrrgrfh79hng2gp0y9aq"
	// Incentive Pools wallet address
	IncentivePools = "pylo1m8dczugvz5sa8qe6h0ehcd92uqr9hpm55ulp55"
	// Foundation Discretionary wallet address
	FoundationDiscretionary = "pylo1d4u3yf6x382medzspuwtnv6jl6q73j0hshjmsr"
	// Token Presale wallet address
	TkPreSale = "pylo1wukgguc6z3fxw8zcdzfwkzpqc67xkhul9mra7f"
	// Token CF Sale wallet address
	TkCFSale = "pylo1pu0h7cyx8waj3c6rqmagv3ll5qvygyxvtnzyvv"
	// Token Reg D+S Sale wallet address
	TkRegDSSale = "pylo1qufsv679033gm7x372hdwc00gzs32f7r4hjjmu"
	// Company Revenue wallet address
	CompanyRevenue = "pylo1hpgtmcvtcnnzt5k8zaxgrzd7dtg76575grpcnv"
	// Engineering Hot Wallet wallet address
	EngineHotWal = "pylo1zag5vc7nfwa0scyrzfdsjj000xexfeyd956pqh"
	//----------- FAKE ADDRESS---------------//
)

var (
	Accounts = []string{
		StakeholderDistribution,
		IncentivePools,
		FoundationDiscretionary,
		TkPreSale,
		TkCFSale,
		TkRegDSSale,
		CompanyRevenue,
		EngineHotWal,
	}

	TotalUbedrock = math.NewIntFromUint64(1_000_000_000_000_000) // 1 bedrock = 1_000_000 ubedrock

	UbedrockDistribute = map[string]math.Int{
		Accounts[0]: math.NewIntFromUint64(150_000_000_000_000),
		Accounts[1]: math.NewIntFromUint64(150_000_000_000_000),
		Accounts[2]: math.ZeroInt(),
		Accounts[3]: math.NewIntFromUint64(20_000_000_000_000),
		Accounts[4]: math.NewIntFromUint64(40_000_000_000_000),
		Accounts[5]: math.NewIntFromUint64(20_000_000_000_000),
		Accounts[6]: math.NewIntFromUint64(619_999_000_000_000),
		Accounts[7]: math.NewIntFromUint64(1_000_000_000),
	}
	_ = Accounts
	_ = TotalUbedrock
	_ = UbedrockDistribute
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

		if types.IsMainnet(ctx.ChainID()) {
			// TODO: Logic upgadeHandler
			bankBaseKeeper, _ := bankKeeper.(bankkeeper.BaseKeeper)
			BurnToken(ctx, types.StakingCoinDenom, accKeeper, &bankBaseKeeper, staking)
			BurnToken(ctx, types.StripeCoinDenom, accKeeper, &bankBaseKeeper, staking)
			MintUbedrockForInitialAccount(ctx, &bankBaseKeeper, staking)
		}
		return mm.RunMigrations(ctx, configurator, fromVM)
	}
}

// TODO: Function helper for upgradeHandler
// Burn denom token
func BurnToken(ctx sdk.Context, denom string, accKeeper *authkeeper.AccountKeeper, bank *bankkeeper.BaseKeeper, staking *stakingkeeper.Keeper) {
	if denom == types.StakingCoinDenom {
		// Get coin back from validator
		accounts := accKeeper.GetAllAccounts(ctx)
		for _, acc := range accounts {
			_, ok := acc.(*authtypes.ModuleAccount)
			if !ok {
				GetbackCoinFromVal(ctx, acc.GetAddress(), staking)
			}
		}
	}

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

// Mint ubedrock for 8 security account
func MintUbedrockForInitialAccount(ctx sdk.Context, bank *bankkeeper.BaseKeeper, staking *stakingkeeper.Keeper) {
	// Mint coin for module
	err := bank.MintCoins(ctx, types.PaymentsProcessorName, sdk.NewCoins(sdk.NewCoin(types.StakingCoinDenom, TotalUbedrock)))
	if err != nil {
		panic(err)
	}

	// Send coin from module to account
	for _, acc := range Accounts {
		err = bank.SendCoinsFromModuleToAccount(
			ctx,
			types.PaymentsProcessorName,
			sdk.MustAccAddressFromBech32(acc),
			sdk.NewCoins(sdk.NewCoin(types.StakingCoinDenom, UbedrockDistribute[acc])),
		)
		if err != nil {
			panic(err)
		}
	}

	// Send 1 bedrock to each validator = 1_000_000 ubedrock
	vals := staking.GetAllValidators(ctx)
	for _, val := range vals {
		_, err = staking.Delegate(
			ctx,
			sdk.MustAccAddressFromBech32(EngineHotWal),
			math.NewIntFromUint64(1_000_000),
			stakingtypes.Unbonded,
			val,
			true,
		)
		if err != nil {
			panic(err)
		}
	}
}

func GetbackCoinFromVal(ctx sdk.Context, accAddr sdk.AccAddress, staking *stakingkeeper.Keeper) {
	now := ctx.BlockHeader().Time

	// this loop will complete all delegator's active redelegations
	for _, activeRedelegation := range staking.GetRedelegations(ctx, accAddr, 65535) {
		// src/dest validator addresses of this redelegation
		redelegationSrc, _ := sdk.ValAddressFromBech32(activeRedelegation.ValidatorSrcAddress)
		redelegationDst, _ := sdk.ValAddressFromBech32(activeRedelegation.ValidatorDstAddress)

		// set all entry completionTime to now so we can complete redelegation
		for i := range activeRedelegation.Entries {
			activeRedelegation.Entries[i].CompletionTime = now
		}

		staking.SetRedelegation(ctx, activeRedelegation)
		_, err := staking.CompleteRedelegation(ctx, accAddr, redelegationSrc, redelegationDst)
		if err != nil {
			panic(err)
		}
	}

	// this loop will turn all delegator's delegations into unbonding delegations
	for _, delegation := range staking.GetAllDelegatorDelegations(ctx, accAddr) {
		validatorValAddr := delegation.GetValidatorAddr()
		_, found := staking.GetValidator(ctx, validatorValAddr)
		if !found {
			continue
		}
		_, err := staking.Undelegate(ctx, accAddr, validatorValAddr, delegation.GetShares()) //nolint:errcheck // nolint because otherwise we'd have a time and nothing to do with it.
		if err != nil {
			panic(err)
		}
	}

	// this loop will complete all delegator's unbonding delegations
	for _, unbondingDelegation := range staking.GetAllUnbondingDelegations(ctx, accAddr) {
		// validator address of this unbonding delegation
		validatorStringAddr := unbondingDelegation.ValidatorAddress
		validatorValAddr, _ := sdk.ValAddressFromBech32(validatorStringAddr)

		// set all entry completionTime to now so we can complete unbonding delegation
		for i := range unbondingDelegation.Entries {
			unbondingDelegation.Entries[i].CompletionTime = now
		}
		staking.SetUnbondingDelegation(ctx, unbondingDelegation)
		_, err := staking.CompleteUnbonding(ctx, accAddr, validatorValAddr)
		if err != nil {
			panic(err)
		}
	}
}

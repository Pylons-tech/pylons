package mainnet

import (
	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
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

	TotalUbedrock = math.NewIntFromUint64(1_000_000_000)

	UbedrockDistribute = map[string]math.Int{
		Accounts[0]: math.NewIntFromUint64(150_000_000),
		Accounts[1]: math.NewIntFromUint64(150_000_000),
		Accounts[2]: math.ZeroInt(),
		Accounts[3]: math.NewIntFromUint64(20_000_000),
		Accounts[4]: math.NewIntFromUint64(40_000_000),
		Accounts[5]: math.NewIntFromUint64(20_000_000),
		Accounts[6]: math.NewIntFromUint64(619_999_000),
		Accounts[7]: math.NewIntFromUint64(1000),
	}
	_ = Accounts
	_ = TotalUbedrock
	_ = UbedrockDistribute
)

// Burn ubedrock
func BurnUbedrock(ctx sdk.Context, bank *bankkeeper.BaseKeeper) {
	// Get all account balances
	accs := bank.GetAccountsBalances(ctx)
	for _, acc := range accs {
		balanceUbedrock := acc.Coins.AmountOf(types.StakingCoinDenom)
		// Check if ubedrock amount GT 0
		if balanceUbedrock.GT(math.ZeroInt()) {
			amount := sdk.NewCoin(types.StakingCoinDenom, balanceUbedrock)
			// Send ubedrock to module
			err := bank.SendCoinsFromAccountToModule(ctx, sdk.MustAccAddressFromBech32(acc.Address), types.PaymentsProcessorName, sdk.NewCoins(amount))
			if err != nil {
				panic(err)
			}
			// Burn ubedrock in module
			err = bank.BurnCoins(ctx, types.PaymentsProcessorName, sdk.NewCoins(amount))
			if err != nil {
				panic(err)
			}
		}
	}
}

// Mint ubedrock for 8 security account
func MintUbedrockForInitialAccount(ctx sdk.Context, bank *bankkeeper.BaseKeeper) {
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
}

package mainnet

import (
	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
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

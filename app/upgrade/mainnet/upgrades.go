package mainnet

import (
	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
)

// Burn ubedrock
func BurnUbedrock(ctx sdk.Context, bk bankkeeper.Keeper) {
	// Send all ubedrock to module
	accs := bk.GetAccountsBalances(ctx)
	totalubedrock := sdk.NewCoin("ubedrock", sdk.ZeroInt())
	for _, acc := range accs {
		balance := bk.GetBalance(ctx, sdk.AccAddress(acc.Address), "ubedrock")
		if balance.Amount.GT(math.ZeroInt()) {
			totalubedrock.Add(balance)
			err := bk.SendCoinsFromAccountToModule(ctx, sdk.AccAddress(acc.Address), types.ModuleName, sdk.NewCoins(balance))
			if err != nil {
				panic(err)
			}
		}
	}
	// Burn ubedrock
	err := bk.BurnCoins(ctx, types.ModuleName, sdk.NewCoins(totalubedrock))
	if err != nil {
		panic(err)
	}
}

// Mint ubedrock for 8 security account
func MintUbedrock(ctx sdk.Context, bk bankkeeper.Keeper) {

}

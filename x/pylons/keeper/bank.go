package keeper

import sdk "github.com/cosmos/cosmos-sdk/types"

// HasEnoughBalance check if user have enough provided coin
func (k Keeper) HasEnoughBalance(ctx sdk.Context, addr sdk.AccAddress, coin sdk.Coin) bool {
	balance := k.bankKeeper.GetBalance(ctx, addr, coin.Denom)

	return !balance.Amount.LT(coin.Amount)
}

// HasEnoughIBCDenomBalance check if user have enough IBC Tokens of coin
// We are getting denom traces and checking balances of User
// Local Denom match with IBC denom
func (k Keeper) HasEnoughIBCDenomBalance(ctx sdk.Context, addr sdk.AccAddress, coin sdk.Coin) bool {
	denomTrace, found := k.GetDenomTrace(ctx, coin)
	if found {
		coin.Denom = denomTrace.IBCDenom()
		balance := k.bankKeeper.GetBalance(ctx, addr, coin.Denom)
		return !balance.Amount.LT(coin.Amount)
	}

	return false
}

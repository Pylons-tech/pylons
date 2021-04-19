package types

import (
	"sort"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CoinInputList []CoinInput

// ToCoins converts to coins
func (cil CoinInputList) ToCoins() sdk.Coins {
	var coins sdk.Coins
	for _, ci := range cil {
		coins = append(coins, sdk.NewInt64Coin(ci.Coin, ci.Count))
	}
	sort.Sort(coins)
	return coins
}

// Equal compares two inputlists
func (cil CoinInputList) Equal(other CoinInputList) bool {
	for _, inp := range cil {
		found := false
		for _, oinp := range other {
			if oinp.Coin == inp.Coin && oinp.Count == inp.Count {
				found = true
				break
			}
		}
		if !found {
			return false
		}
	}

	return true
}

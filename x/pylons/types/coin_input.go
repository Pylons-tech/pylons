package types

import (
	"sort"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// CoinInputList is a list of Coin inputs
type CoinInputList2 []CoinInput

// ToCoins converts to coins
func (cil CoinInputList) ToCoins() sdk.Coins {
	var coins sdk.Coins
	for _, ci := range cil.Coins {
		coins = append(coins, sdk.NewInt64Coin(ci.Coin, ci.Count))
	}
	sort.Sort(coins)
	return coins
}

func (cil CoinInputList) StringS() string {
	output := "CoinInputList{"

	for _, input := range cil.Coins {
		output += input.String() + ",\n"
	}

	output += "}"
	return output

}

// Equal compares two inputlists
func (cil CoinInputList) Equal(other CoinInputList) bool {
	for _, inp := range cil.Coins {
		found := false
		for _, oinp := range other.Coins {
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

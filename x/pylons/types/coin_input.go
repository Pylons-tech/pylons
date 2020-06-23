package types

import (
	"fmt"
	"sort"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// CoinInput is the game elements that are needs as inputs to a recipe
type CoinInput struct {
	Coin  string
	Count int64 `json:",string"` // TODO: This is added since we are using json.Marshal and amino Marshal together, when we convert all the Marshal into amino json:",string" can be removed
}

func (ip CoinInput) String() string {
	return fmt.Sprintf(`CoinInput{
		Coin: %s,
		Count: %d,
		}`, ip.Coin, ip.Count)
}

// CoinInputList is a list of Coin inputs
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

func (cil CoinInputList) String() string {
	output := "CoinInputList{"

	for _, input := range cil {
		output += input.String() + ",\n"
	}

	output += "}"
	return output

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

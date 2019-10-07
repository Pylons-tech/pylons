package types

import (
	"fmt"
)

// CoinInput is the game elements that are needs as inputs to a recipe
type CoinInput struct {
	Coin  string
	Count int64 `json:",string"`
}

func (ip CoinInput) String() string {
	return fmt.Sprintf(`CoinInput{
		Coin: %s,
		Count: %d,
		}`, ip.Coin, ip.Count)
}

// CoinInputList is a list of Coin inputs
type CoinInputList []CoinInput

func (ipl CoinInputList) String() string {
	output := "CoinInputList{"

	for _, input := range ipl {
		output += input.String() + ",\n"
	}

	output += "}"
	return output

}

// Equal compares two inputlists
func (ipl CoinInputList) Equal(other CoinInputList) bool {
	for _, inp := range ipl {
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

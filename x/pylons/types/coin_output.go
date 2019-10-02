package types

import "fmt"

// CoinOutput is the game elements that are needs as output to a recipe
type CoinOutput struct {
	Coin   string
	Count  int64
	Weight int
}

func (op CoinOutput) GetWeight() int {
	return op.Weight
}

func (op CoinOutput) String() string {
	return fmt.Sprintf(`CoinOutput{
		Coin: %s,
		Count: %d,
		Weight: %d,
	}`, op.Coin, op.Count, op.Weight)
}

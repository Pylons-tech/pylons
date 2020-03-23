package types

import "fmt"

// CoinOutput is the game elements that are needs as output to a recipe
type CoinOutput struct {
	Coin    string
	Count   int64
	Program string
}

func (op CoinOutput) String() string {
	return fmt.Sprintf(`CoinOutput{
		Coin: %s,
		Count: %d,
	}`, op.Coin, op.Count)
}

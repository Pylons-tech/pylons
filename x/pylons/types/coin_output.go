package types

import "fmt"

// CoinOutput is the game elements that are needs as output to a recipe
type CoinOutput struct {
	Coin  string
	Count int64
}

func (op CoinOutput) String() string {
	return fmt.Sprintf(`CoinOutput{
		Coin: %s,
		Count: %d,
		}`, op.Coin, op.Count)
}

// CoinOutputList is the list of outputs
type CoinOutputList []CoinOutput

func (opl CoinOutputList) String() string {
	opt := "CoinOutputList{"

	for _, output := range opl {
		opt += output.String() + ",\n"
	}

	opt += "}"
	return opt

}

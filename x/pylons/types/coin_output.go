package types

import "fmt"

// CoinOutput is the game elements that are needs as output to a recipe
type CoinOutput struct {
	ID    string
	Coin  string
	Count string // coin output count is parsed by cel program
}

// GetID returns ID of coin output
func (op CoinOutput) GetID() string {
	return op.ID
}

func (op CoinOutput) String() string {
	return fmt.Sprintf(`CoinOutput{
		ID: %s,
		Coin: %s,
		Count: %s,
	}`, op.ID, op.Coin, op.Count)
}

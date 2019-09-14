package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Execution is a recipe execution used for tracking the execution - specifically a
// scheduled execution
type Execution struct {
	ID          string
	RecipeID    string // the recipe guid
	CoinInputs  sdk.Coins
	CoinOutputs sdk.Coins
	ItemInputs  []Item
	ItemOutputs []Item
	BlockHeight int64
	Sender      sdk.AccAddress
	Completed   bool
}

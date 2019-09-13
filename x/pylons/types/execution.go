package types

import sdk "github.com/cosmos/cosmos-sdk/types"

// Execution is a recipe execution used for tracking the execution - specifically a
// scheduled execution
type Execution struct {
	RecipeID    string // the recipe guid
	CoinInputs  CoinInputList
	CoinOutputs CoinOutputList
	ItemInputs  []Item
	ItemOutputs []Item
	BlockHeight int64
	Sender      sdk.AccAddress
}

package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeExecution is a store key for execution
const TypeExecution = "execution"

// NewExecution return a new Execution
func NewExecution(recipeID string, cookbookID string, ci sdk.Coins,
	itemInputs []Item,
	blockHeight int64, sender sdk.AccAddress,
	completed bool) Execution {

	exec := Execution{
		NodeVersion: "0.0.1",
		RecipeID:    recipeID,
		CookbookID:  cookbookID,
		CoinInputs:  ci,
		ItemInputs:  itemInputs,
		BlockHeight: blockHeight,
		Sender:      sender.String(),
		Completed:   completed,
	}

	exec.ID = KeyGen(sender)
	return exec
}

package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeExecution is a store key for execution
const TypeExecution = "execution"

// Execution is a recipe execution used for tracking the execution - specifically a
// scheduled execution
type Execution struct {
	ID          string
	RecipeID    string // the recipe guid
	CookbookID  string
	CoinInputs  sdk.Coins
	ItemInputs  []Item
	BlockHeight int64
	Sender      sdk.AccAddress
	Completed   bool
}

// ExecutionList describes executions list
type ExecutionList struct {
	Executions []Execution
}

// NewExecution return a new Execution
func NewExecution(recipeID string, cookbookID string, ci sdk.Coins,
	itemInputs []Item,
	blockHeight int64, sender sdk.AccAddress,
	completed bool) Execution {

	exec := Execution{
		RecipeID:    recipeID,
		CookbookID:  cookbookID,
		CoinInputs:  ci,
		ItemInputs:  itemInputs,
		BlockHeight: blockHeight,
		Sender:      sender,
		Completed:   completed,
	}

	exec.ID = KeyGen(sender)
	return exec
}

func (e Execution) String() string {
	return fmt.Sprintf(`
		Execution{ 
			ID: %s,
			RecipeID: %s,
			CookbookID: %s,
			CoinInputs: %+v,
			ItemInputs: %+v,
			BlockHeight: %d,
			Sender: %s,
			Completed: %t,
		}`, e.ID, e.RecipeID, e.CookbookID, e.CoinInputs, e.ItemInputs,
		e.BlockHeight, e.Sender, e.Completed)
}

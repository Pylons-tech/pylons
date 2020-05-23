package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

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

type ExecutionList struct {
	Executions []Execution
}

// NewExecution return a new Execution
func NewExecution(rcpID string, cbID string, ci sdk.Coins,
	itemInputs []Item,
	blockHeight int64, sender sdk.AccAddress,
	completed bool) Execution {

	exec := Execution{
		RecipeID:    rcpID,
		CookbookID:  cbID,
		CoinInputs:  ci,
		ItemInputs:  itemInputs,
		BlockHeight: blockHeight,
		Sender:      sender,
		Completed:   completed,
	}

	exec.ID = exec.KeyGen()
	return exec
}

// KeyGen generates key for the execution
func (exec Execution) KeyGen() string {
	uuid.SetRand(NewEntropyReader())
	id := uuid.New()
	return exec.Sender.String() + id.String()
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

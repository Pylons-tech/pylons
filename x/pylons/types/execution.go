package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

// Execution is a recipe execution used for tracking the execution - specifically a
// scheduled execution
type Execution struct {
	ID          string
	RecipeID    string // the recipe guid
	CookbookID  string
	CoinInputs  sdk.Coins
	ItemInputs  []Item
	Entries     WeightedParamList
	BlockHeight int64
	Sender      sdk.AccAddress
	Completed   bool
}

// KeyGen generates key for the execution
func (exec Execution) KeyGen() string {
	id := uuid.New()
	return exec.Sender.String() + id.String()
}

func (e Execution) String() string {
	return fmt.Sprintf(`
		Item{ 
			ID: %s,
			RecipeID: %s,
			CookbookID: %s,
			CoinInputs: %+v,
			ItemInputs: %+v,
			Entries: %+v,
			BlockHeight: %d,
			Sender: %s,
			Completed: %t,
		}`, e.ID, e.RecipeID, e.CookbookID, e.CoinInputs, e.ItemInputs,
		e.Entries, e.BlockHeight, e.Sender, e.Completed)
}

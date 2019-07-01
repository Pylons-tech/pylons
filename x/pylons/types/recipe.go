package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

// Recipe is a game state machine step abstracted out as a cooking terminology
type Recipe struct {
	CookbookName  string // the cookbook guid
	ID            string // the recipe guid
	Inputs        InputList
	Outputs       OutputList
	ExecutionTime int64
	Sender        sdk.AccAddress
}

func NewRecipe(cookbookName string, ID string, inputs InputList, outputs OutputList, execTime int64) Recipe {
	return Recipe{
		CookbookName:  cookbookName,
		ID:            ID,
		Inputs:        inputs,
		Outputs:       outputs,
		ExecutionTime: execTime,
	}
}

func (rcp *Recipe) String() string {
	return fmt.Sprintf(`Recipe{
		CookbookName: %s,
		ID: %s,
		Inputs: %s,
		Outputs: %s,
		ExecutionTIme: %d,
	}`, rcp.CookbookName, rcp.ID, rcp.Inputs.String(), rcp.Outputs.String(), rcp.ExecutionTime)
}

// KeyGen generates key for the store
func (rc Recipe) KeyGen() string {
	id := uuid.New()
	return rc.Sender.String() + id.String()
}


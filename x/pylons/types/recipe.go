package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeRecipe is a store key for recipe
const TypeRecipe = "recipe"

// Recipe is a game state machine step abstracted out as a cooking terminology
type Recipe struct {
	ID            string // the recipe guid
	CookbookID    string // the cookbook guid
	Name          string
	CoinInputs    CoinInputList
	ItemInputs    ItemInputList
	Entries       EntriesList
	Outputs       WeightedOutputsList
	Description   string
	BlockInterval int64
	Sender        sdk.AccAddress
	Disabled      bool
}

// RecipeList is a list of recipes
type RecipeList struct {
	Recipes []Recipe
}

func (rl RecipeList) String() string {
	output := "RecipeList{"
	for _, r := range rl.Recipes {
		output += r.String()
		output += ",\n"
	}
	output += "}"
	return output
}

// NewRecipe creates a new recipe
func NewRecipe(recipeName, cookbookID, description string,
	coinInputs CoinInputList, // coins to put on the recipe
	itemInputs ItemInputList, // items to put on the recipe
	entries EntriesList, // items that can be created from recipe
	outputs WeightedOutputsList, // item outputs listing by weight value
	blockInterval int64, // The amount of time to wait to finish running the recipe
	sender sdk.AccAddress) Recipe {
	rcp := Recipe{
		Name:          recipeName,
		CookbookID:    cookbookID,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		Outputs:       outputs,
		BlockInterval: blockInterval,
		Description:   description,
		Sender:        sender,
	}

	rcp.ID = KeyGen(sender)
	return rcp
}

func (rcp Recipe) String() string {
	return fmt.Sprintf(`Recipe{
		Name: %s,
		CookbookID: %s,
		ID: %s,
		CoinInputs: %s,
		ItemInputs: %s,
		Entries: %s,
		ExecutionTime: %d,
	}`, rcp.Name, rcp.CookbookID, rcp.ID,
		rcp.CoinInputs.String(),
		rcp.ItemInputs.String(),
		rcp.Entries.String(),
		rcp.BlockInterval)
}

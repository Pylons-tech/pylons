package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

type RecipeType int

const (
	GENERATION RecipeType = iota
	UPGRADE
)

const TypeRecipe = "recipe"

// Recipe is a game state machine step abstracted out as a cooking terminology
type Recipe struct {
	ID             string // the recipe guid
	CookbookID     string // the cookbook guid
	Name           string
	RType          RecipeType // GENERATION | UPGRADE
	CoinInputs     CoinInputList
	ItemInputs     ItemInputList
	CatalystInputs CatalystItemInputList
	Entries        WeightedParamList
	ToUpgrade      ItemUpgradeParams
	Description    string
	BlockInterval  int64
	Sender         sdk.AccAddress
	Disabled       bool
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
	rcpType RecipeType,
	coinInputs CoinInputList, // coinOutputs CoinOutputList,
	itemInputs ItemInputList, // itemOutputs ItemOutputList,
	catalystInputs CatalystItemInputList,
	entries WeightedParamList, // newly created param instead of coinOutputs and itemOutputs
	toUpgrade ItemUpgradeParams,
	execTime int64, sender sdk.AccAddress) Recipe {
	rcp := Recipe{
		Name:           recipeName,
		CookbookID:     cookbookID,
		RType:          rcpType,
		CoinInputs:     coinInputs,
		ItemInputs:     itemInputs,
		CatalystInputs: catalystInputs,
		Entries:        entries,
		ToUpgrade:      toUpgrade,
		BlockInterval:  execTime,
		Description:    description,
		Sender:         sender,
	}

	rcp.ID = rcp.KeyGen()
	return rcp
}

func (rcp Recipe) String() string {
	return fmt.Sprintf(`Recipe{
		Name: %s,
		CookbookID: %s,
		ID: %s,
		CoinInputs: %s,
		ItemInputs: %s,
		CatalystInputs: %s,
		Entries: %s,
		ExecutionTime: %d,
	}`, rcp.Name, rcp.CookbookID, rcp.ID,
		rcp.CoinInputs.String(),
		rcp.ItemInputs.String(),
		rcp.CatalystInputs.String(),
		rcp.Entries.String(),
		rcp.BlockInterval)
}

// KeyGen generates key for the store
func (rcp Recipe) KeyGen() string {
	id := uuid.New()
	return rcp.Sender.String() + id.String()
}

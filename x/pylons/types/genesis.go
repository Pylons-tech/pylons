package types

import (
	"fmt"
	// this line is used by starport scaffolding # ibc/genesistype/import
)

// DefaultIndex is the default capability global index
const DefaultIndex uint64 = 1

// DefaultGenesis returns the default Capability genesis state
func DefaultGenesis() *GenesisState {
	return &GenesisState{
		// this line is used by starport scaffolding # ibc/genesistype/default
		// this line is used by starport scaffolding # genesis/types/default
GooglIAPOrderList: []*GooglIAPOrder{},
		PendingExecutionList: []*Execution{},
		ExecutionList:        []*Execution{},
		ItemList:             []*Item{},
		RecipeList:           []*Recipe{},
		CookbookList:         []*Cookbook{},
	}
}

// Validate performs basic genesis state validation returning an error upon any
// failure.
func (gs GenesisState) Validate() error {
	// this line is used by starport scaffolding # ibc/genesistype/validate

	// this line is used by starport scaffolding # genesis/types/validate
// Check for duplicated ID in googlIAPOrder
googlIAPOrderIdMap := make(map[uint64]bool)

for _, elem := range gs.GooglIAPOrderList {
	if _, ok := googlIAPOrderIdMap[elem.Id]; ok {
		return fmt.Errorf("duplicated id for googlIAPOrder")
	}
	googlIAPOrderIdMap[elem.Id] = true
}
	// Check for duplicated ID in pendingExecution
	pendingExecutionIDMap := make(map[string]bool)

	for _, elem := range gs.PendingExecutionList {
		if _, ok := pendingExecutionIDMap[elem.ID]; ok {
			return fmt.Errorf("duplicated id for pending execution")
		}
		pendingExecutionIDMap[elem.ID] = true
	}

	// Check for duplicated ID in execution
	executionIDMap := make(map[string]bool)

	for _, elem := range gs.ExecutionList {
		if _, ok := executionIDMap[elem.ID]; ok {
			return fmt.Errorf("duplicated id for execution")
		}
		executionIDMap[elem.ID] = true
	}
	// Check for duplicated index in item
	itemIndexMap := make(map[string]bool)

	for _, elem := range gs.ItemList {
		if _, ok := itemIndexMap[elem.ID]; ok {
			return fmt.Errorf("duplicated index for item")
		}
		itemIndexMap[elem.ID] = true
	}
	// Check for duplicated index in recipe
	recipeIndexMap := make(map[string]bool)

	for _, elem := range gs.RecipeList {
		if _, ok := recipeIndexMap[elem.ID]; ok {
			return fmt.Errorf("duplicated index for recipe")
		}
		recipeIndexMap[elem.ID] = true
	}
	// Check for duplicated index in cookbook
	cookbookIndexMap := make(map[string]bool)

	for _, elem := range gs.CookbookList {
		if _, ok := cookbookIndexMap[elem.ID]; ok {
			return fmt.Errorf("duplicated index for cookbook")
		}
		cookbookIndexMap[elem.ID] = true
	}

	return nil
}

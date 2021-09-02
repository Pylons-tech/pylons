package types

import (
	"fmt"
	// this line is used by starport scaffolding # ibc/genesistype/import
)

// DefaultIndex is the default capability global index
const DefaultIndex uint64 = 1

// DefaultGenesis returns the default Pylons genesis state
func DefaultGenesis() *GenesisState {
	return &GenesisState{
		// this line is used by starport scaffolding # ibc/genesistype/default
		// this line is used by starport scaffolding # genesis/types/default
		PylonsAccountList:            []PylonsAccount{},
		TradeList:                    []Trade{},
		GoogleInAppPurchaseOrderList: []GoogleInAppPurchaseOrder{},
		PendingExecutionList:         []Execution{},
		ExecutionList:                []Execution{},
		ItemList:                     []Item{},
		RecipeList:                   []Recipe{},
		CookbookList:                 []Cookbook{},
		Params:                       DefaultParams(),
	}
}

// Validate performs basic genesis state validation returning an error upon any
// failure.
func (gs GenesisState) Validate() error {
	// this line is used by starport scaffolding # ibc/genesistype/validate

	// this line is used by starport scaffolding # genesis/types/validate
	// Check for duplicated index in username
	usernameIndexMap := make(map[string]bool)

	for _, elem := range gs.PylonsAccountList {
		if _, ok := usernameIndexMap[elem.Account]; ok {
			return fmt.Errorf("duplicated creator for username")
		}
		usernameIndexMap[elem.Account] = true
	}
	// Check for duplicated ID in trade
	tradeIDMap := make(map[uint64]bool)

	for _, elem := range gs.TradeList {
		if _, ok := tradeIDMap[elem.ID]; ok {
			return fmt.Errorf("duplicated id for trade")
		}
		tradeIDMap[elem.ID] = true
	}
	// Check for duplicated ID in googleIAPOrder
	googleIAPOrderIDMap := make(map[string]bool)

	for _, elem := range gs.GoogleInAppPurchaseOrderList {
		if _, ok := googleIAPOrderIDMap[elem.PurchaseToken]; ok {
			return fmt.Errorf("duplicated purchaseToken for googleInAppPurchaseOrder")
		}
		googleIAPOrderIDMap[elem.PurchaseToken] = true
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

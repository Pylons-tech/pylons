package v1beta1

import (
	"fmt"
)

// DefaultIndex is the default capability global index
const DefaultIndex uint64 = 1

// DefaultGenesis returns the default Pylons genesis state
func DefaultGenesis() *GenesisState {
	return &GenesisState{
		RedeemInfoList:               []RedeemInfo{},
		PaymentInfoList:              []PaymentInfo{},
		AccountList:                  []UserMap{},
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

// NetworkTestGenesis returns the network test Pylons genesis state
func NetworkTestGenesis() *GenesisState {
	return &GenesisState{
		AccountList:                  []UserMap{},
		TradeList:                    []Trade{},
		GoogleInAppPurchaseOrderList: []GoogleInAppPurchaseOrder{},
		PendingExecutionList:         []Execution{},
		ExecutionList:                []Execution{},
		ItemList:                     []Item{},
		RecipeList:                   []Recipe{},
		CookbookList:                 []Cookbook{},
		Params:                       NetworkTestParams(),
	}
}

// Validate performs basic genesis state validation returning an error upon any
// failure.
func (gs GenesisState) Validate() error {
	// Check for duplicated index in redeemInfo
	redeemInfoIndexMap := make(map[string]bool)

	for _, elem := range gs.RedeemInfoList {
		if _, ok := redeemInfoIndexMap[elem.Id]; ok {
			return fmt.Errorf("duplicated index for redeemInfo")
		}
		redeemInfoIndexMap[elem.Id] = true
	}
	// Check for duplicated index in paymentInfo
	paymentInfoIndexMap := make(map[string]bool)

	for _, elem := range gs.PaymentInfoList {
		if _, ok := paymentInfoIndexMap[elem.PurchaseId]; ok {
			return fmt.Errorf("duplicated index for paymentInfo")
		}
		paymentInfoIndexMap[elem.PurchaseId] = true
	}
	// Check for duplicated index in username
	accountAddrIndexMap := make(map[string]bool)
	usernameIndexMap := make(map[string]bool)

	for _, elem := range gs.AccountList {
		if _, ok := accountAddrIndexMap[elem.AccountAddr]; ok {
			return fmt.Errorf("duplicated account")
		}
		accountAddrIndexMap[elem.AccountAddr] = true

		if _, ok := usernameIndexMap[elem.Username]; ok {
			return fmt.Errorf("duplicated username" +
				"")
		}
		usernameIndexMap[elem.Username] = true
	}

	// Check for duplicated ID in trade
	tradeIDMap := make(map[uint64]bool)

	for _, elem := range gs.TradeList {
		if _, ok := tradeIDMap[elem.Id]; ok {
			return fmt.Errorf("duplicated id for trade")
		}
		tradeIDMap[elem.Id] = true
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
		if _, ok := pendingExecutionIDMap[elem.Id]; ok {
			return fmt.Errorf("duplicated id for pending execution")
		}
		pendingExecutionIDMap[elem.Id] = true
	}

	// Check for duplicated ID in execution
	executionIDMap := make(map[string]bool)

	for _, elem := range gs.ExecutionList {
		if _, ok := executionIDMap[elem.Id]; ok {
			return fmt.Errorf("duplicated id for execution")
		}
		executionIDMap[elem.Id] = true
	}
	// Check for duplicated index in item
	itemIndexMap := make(map[string]bool)

	for _, elem := range gs.ItemList {
		if _, ok := itemIndexMap[elem.Id]; ok {
			return fmt.Errorf("duplicated index for item")
		}
		itemIndexMap[elem.Id] = true
	}
	// Check for duplicated index in recipe
	recipeIndexMap := make(map[string]bool)

	for _, elem := range gs.RecipeList {
		if _, ok := recipeIndexMap[elem.Id]; ok {
			return fmt.Errorf("duplicated index for recipe")
		}
		recipeIndexMap[elem.Id] = true
	}
	// Check for duplicated index in cookbook
	cookbookIndexMap := make(map[string]bool)

	for _, elem := range gs.CookbookList {
		if _, ok := cookbookIndexMap[elem.Id]; ok {
			return fmt.Errorf("duplicated index for cookbook")
		}
		cookbookIndexMap[elem.Id] = true
	}

	return nil
}

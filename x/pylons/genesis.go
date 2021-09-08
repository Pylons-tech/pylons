package pylons

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// InitGenesis initializes the capability module's state from a provided genesis
// state.
func InitGenesis(ctx sdk.Context, k keeper.Keeper, genState types.GenesisState) {
	// this line is used by starport scaffolding # genesis/module/init
	// Set all the account mappings
	for _, elem := range genState.AccountList {
		username := types.Username{Value: elem.Username}
		accountAddr := types.AccountAddr{Value: elem.Account}
		k.SetPylonsAccount(ctx, accountAddr, username)
	}

	// Set all the trade
	for _, elem := range genState.TradeList {
		k.SetTrade(ctx, elem)
	}

	// Set trade count
	k.SetTradeCount(ctx, genState.TradeCount)

	// Set all the googlIAPOrder
	for _, elem := range genState.GoogleInAppPurchaseOrderList {
		k.SetGoogleIAPOrder(ctx, elem)
	}

	// Set googlIAPOrder count
	k.SetGoogleIAPOrderCount(ctx, genState.GoogleIAPOrderCount)

	// Set all the execution
	for _, elem := range genState.ExecutionList {
		k.SetExecution(ctx, elem)
	}

	// Set execution count
	k.SetExecutionCount(ctx, genState.ExecutionCount)

	// Set all the pending execution
	for _, elem := range genState.PendingExecutionList {
		k.SetPendingExecution(ctx, elem)
	}

	// Set execution count
	k.SetExecutionCount(ctx, genState.PendingExecutionCount)

	// Set all the item
	for _, elem := range genState.ItemList {
		k.SetItem(ctx, elem)
	}

	// Set all the recipe
	for _, elem := range genState.RecipeList {
		k.SetRecipe(ctx, elem)
	}

	// Set all the cookbook
	for _, elem := range genState.CookbookList {
		k.SetCookbook(ctx, elem)
	}

	k.SetParams(ctx, genState.Params)

	// this line is used by starport scaffolding # ibc/genesis/init
}

// ExportGenesis returns the capability module's exported genesis.
func ExportGenesis(ctx sdk.Context, k keeper.Keeper) *types.GenesisState {
	genesis := types.DefaultGenesis()

	// Set the current count
	genesis.EntityCount = k.GetEntityCount(ctx)

	// this line is used by starport scaffolding # genesis/module/export
	// Get all username
	usernameList := k.GetAllPylonsAccount(ctx)
	for _, elem := range usernameList {
		elem := elem
		genesis.AccountList = append(genesis.AccountList, elem)
	}

	// Get all trade
	tradeList := k.GetAllTrade(ctx)
	for _, elem := range tradeList {
		elem := elem
		genesis.TradeList = append(genesis.TradeList, elem)
	}

	// Set the current count
	genesis.TradeCount = k.GetTradeCount(ctx)

	// Get all googlIAPOrder
	googlIAPOrderList := k.GetAllGoogleIAPOrder(ctx)
	for _, elem := range googlIAPOrderList {
		elem := elem
		genesis.GoogleInAppPurchaseOrderList = append(genesis.GoogleInAppPurchaseOrderList, elem)
	}

	// Set the current count
	genesis.GoogleIAPOrderCount = k.GetGoogleIAPOrderCount(ctx)

	// Get all pending execution
	pendingExecutionList := k.GetAllPendingExecution(ctx)
	for _, elem := range pendingExecutionList {
		elem := elem
		genesis.PendingExecutionList = append(genesis.PendingExecutionList, elem)
	}

	// Set the current count
	genesis.PendingExecutionCount = k.GetPendingExecutionCount(ctx)

	// Get all execution
	executionList := k.GetAllExecution(ctx)
	for _, elem := range executionList {
		elem := elem
		genesis.ExecutionList = append(genesis.ExecutionList, elem)
	}

	// Set the current count
	genesis.ExecutionCount = k.GetExecutionCount(ctx)

	// Get all item
	itemList := k.GetAllItem(ctx)
	for _, elem := range itemList {
		elem := elem
		genesis.ItemList = append(genesis.ItemList, elem)
	}

	// Get all recipe
	recipeList := k.GetAllRecipe(ctx)
	for _, elem := range recipeList {
		elem := elem
		genesis.RecipeList = append(genesis.RecipeList, elem)
	}

	// Get all cookbook
	cookbookList := k.GetAllCookbook(ctx)
	for _, elem := range cookbookList {
		elem := elem
		genesis.CookbookList = append(genesis.CookbookList, elem)
	}

	params := k.GetParams(ctx)
	genesis.Params = params
	// this line is used by starport scaffolding # ibc/genesis/export

	return genesis
}

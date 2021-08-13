package pylons

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// InitGenesis initializes the capability module's state from a provided genesis
// state.
func InitGenesis(ctx sdk.Context, k keeper.Keeper, bk types.BankKeeper, genState types.GenesisState) {
	// this line is used by starport scaffolding # genesis/module/init
// Set all the googlIAPOrder
for _, elem := range genState.GooglIAPOrderList {
	k.SetGoogleIAPOrder(ctx, *elem)
}

// Set googlIAPOrder count
k.SetGooglIAPOrderCount(ctx, genState.GooglIAPOrderCount)

	// Set all the execution
	for _, elem := range genState.ExecutionList {
		k.SetExecution(ctx, *elem)
	}

	// Set execution count
	k.SetExecutionCount(ctx, genState.ExecutionCount)

	// Set all the pending execution
	for _, elem := range genState.PendingExecutionList {
		k.SetPendingExecution(ctx, *elem)
	}

	// Set execution count
	k.SetExecutionCount(ctx, genState.PendingExecutionCount)

	// Set all the item
	for _, elem := range genState.ItemList {
		k.SetItem(ctx, *elem)
	}

	// Set all the recipe
	for _, elem := range genState.RecipeList {
		k.SetRecipe(ctx, *elem)
	}

	// Set all the cookbook
	for _, elem := range genState.CookbookList {
		k.SetCookbook(ctx, *elem)
	}

	// this line is used by starport scaffolding # ibc/genesis/init
}

// ExportGenesis returns the capability module's exported genesis.
func ExportGenesis(ctx sdk.Context, k keeper.Keeper) *types.GenesisState {
	genesis := types.DefaultGenesis()

	// this line is used by starport scaffolding # genesis/module/export
// Get all googlIAPOrder
googlIAPOrderList := k.GetAllGoogleIAPOrder(ctx)
for _, elem := range googlIAPOrderList {
	elem := elem
	genesis.GooglIAPOrderList = append(genesis.GooglIAPOrderList, &elem)
}

// Set the current count
genesis.GooglIAPOrderCount = k.GetGooglIAPOrderCount(ctx)

	// Get all pending execution
	pendingExecutionList := k.GetAllPendingExecution(ctx)
	for _, elem := range pendingExecutionList {
		elem := elem
		genesis.PendingExecutionList = append(genesis.PendingExecutionList, &elem)
	}

	// Set the current count
	genesis.PendingExecutionCount = k.GetPendingExecutionCount(ctx)

	// Get all execution
	executionList := k.GetAllExecution(ctx)
	for _, elem := range executionList {
		elem := elem
		genesis.ExecutionList = append(genesis.ExecutionList, &elem)
	}

	// Set the current count
	genesis.ExecutionCount = k.GetExecutionCount(ctx)

	// Get all item
	itemList := k.GetAllItem(ctx)
	for _, elem := range itemList {
		elem := elem
		genesis.ItemList = append(genesis.ItemList, &elem)
	}

	// Get all recipe
	recipeList := k.GetAllRecipe(ctx)
	for _, elem := range recipeList {
		elem := elem
		genesis.RecipeList = append(genesis.RecipeList, &elem)
	}

	// Get all cookbook
	cookbookList := k.GetAllCookbook(ctx)
	for _, elem := range cookbookList {
		elem := elem
		genesis.CookbookList = append(genesis.CookbookList, &elem)
	}

	// this line is used by starport scaffolding # ibc/genesis/export

	return genesis
}

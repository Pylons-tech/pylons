package pylons

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
)

// InitGenesis initializes the capability module's state from a provided genesis
// state.
func InitGenesis(ctx sdk.Context, k keeper.Keeper, genState v1beta1.GenesisState) {
	// Set all the redeemInfo
	for _, elem := range genState.RedeemInfoList {
		k.SetRedeemInfo(ctx, elem)
	}

	// Set all the paymentInfo
	for _, elem := range genState.PaymentInfoList {
		k.SetPaymentInfo(ctx, elem)
	}

	// Set all the account mappings
	for _, elem := range genState.AccountList {
		username := v1beta1.Username{Value: elem.Username}
		accountAddr := v1beta1.AccountAddr{Value: elem.AccountAddr}
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
	k.SetGoogleIAPOrderCount(ctx, genState.GoogleIapOrderCount)

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
}

// ExportGenesis returns the capability module's exported genesis.
func ExportGenesis(ctx sdk.Context, k keeper.Keeper) *v1beta1.GenesisState {
	genesis := v1beta1.DefaultGenesis()

	// Set the current count
	genesis.EntityCount = k.GetEntityCount(ctx)

	// Get all redeemInfo
	redeemInfoList := k.GetAllRedeemInfo(ctx)
	for _, elem := range redeemInfoList {
		elem := elem
		genesis.RedeemInfoList = append(genesis.RedeemInfoList, elem)
	}

	// Get all paymentInfo
	paymentInfoList := k.GetAllPaymentInfo(ctx)
	for _, elem := range paymentInfoList {
		elem := elem
		genesis.PaymentInfoList = append(genesis.PaymentInfoList, elem)
	}

	// Get all username
	usernameList := k.GetAllPylonsAccount(ctx)
	genesis.AccountList = append(genesis.AccountList, usernameList...)

	// Get all trade
	tradeList := k.GetAllTrade(ctx)
	genesis.TradeList = append(genesis.TradeList, tradeList...)

	// Set the current count
	genesis.TradeCount = k.GetTradeCount(ctx)

	// Get all googlIAPOrder
	googlIAPOrderList := k.GetAllGoogleIAPOrder(ctx)
	genesis.GoogleInAppPurchaseOrderList = append(genesis.GoogleInAppPurchaseOrderList, googlIAPOrderList...)

	// Set the current count
	genesis.GoogleIapOrderCount = k.GetGoogleIAPOrderCount(ctx)

	// Get all pending execution
	pendingExecutionList := k.GetAllPendingExecution(ctx)
	genesis.PendingExecutionList = append(genesis.PendingExecutionList, pendingExecutionList...)

	// Set the current count
	genesis.PendingExecutionCount = k.GetPendingExecutionCount(ctx)

	// Get all execution
	executionList := k.GetAllExecution(ctx)
	genesis.ExecutionList = append(genesis.ExecutionList, executionList...)

	// Set the current count
	genesis.ExecutionCount = k.GetExecutionCount(ctx)

	// Get all item
	itemList := k.GetAllItem(ctx)
	genesis.ItemList = append(genesis.ItemList, itemList...)

	// Get all recipe
	recipeList := k.GetAllRecipe(ctx)
	genesis.RecipeList = append(genesis.RecipeList, recipeList...)

	// Get all cookbook
	cookbookList := k.GetAllCookbook(ctx)
	genesis.CookbookList = append(genesis.CookbookList, cookbookList...)

	params := k.GetParams(ctx)
	genesis.Params = params

	return genesis
}

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

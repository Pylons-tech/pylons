package pylons

import (
	"log"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// InitGenesis initializes a context from a genesis state
func InitGenesis(ctx sdk.Context, keeper keeper.Keeper, data types.GenesisState) {
	// TODO handle errors
	for _, record := range data.Cookbooks {
		//nolint:errcheck
		keeper.SetCookbook(ctx, record)
	}
	for _, record := range data.Recipes {
		//nolint:errcheck
		keeper.SetRecipe(ctx, record)
	}
	for _, record := range data.Items {
		//nolint:errcheck
		keeper.SetItem(ctx, record)
	}
}

// ExportGenesis exports current state to new genesis state
func ExportGenesis(ctx sdk.Context, k keeper.Keeper) types.GenesisState {
	var cookbooks []types.Cookbook
	iterator := k.GetCookbooksIterator(ctx)
	for ; iterator.Valid(); iterator.Next() {
		name := string(iterator.Key())
		cookbook, _ := k.GetCookbook(ctx, name)
		cookbooks = append(cookbooks, cookbook)
	}

	recipes := k.GetRecipes(ctx)

	items, err := k.GetAllItems(ctx)
	if err != nil {
		log.Panicln("error while getting items in exportGenesis:", err.Error())
	}

	return types.GenesisState{Cookbooks: cookbooks, Recipes: recipes, Items: items}
}

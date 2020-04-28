package pylons

import (
	"log"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// GenesisState empty genesis for pylons
type GenesisState struct {
	Cookbooks []types.Cookbook
	Recipies  []types.Recipe
	Items     []types.Item
}

func NewGenesisState() GenesisState {
	return GenesisState{}
}

func ValidateGenesis(data GenesisState) error {
	return nil
}

func DefaultGenesisState() GenesisState {
	return GenesisState{
		Cookbooks: []types.Cookbook{},
		Recipies:  []types.Recipe{},
		Items:     []types.Item{},
	}
}

func InitGenesis(ctx sdk.Context, keeper keep.Keeper, data GenesisState) {
	for _, record := range data.Cookbooks {
		keeper.SetCookbook(ctx, record)
	}
	for _, record := range data.Recipies {
		keeper.SetRecipe(ctx, record)
	}
	for _, record := range data.Items {
		keeper.SetItem(ctx, record)
	}
}

func ExportGenesis(ctx sdk.Context, k keep.Keeper) GenesisState {
	var cookbooks []types.Cookbook
	iterator := k.GetCookbooksIterator(ctx)
	for ; iterator.Valid(); iterator.Next() {

		name := string(iterator.Key())
		cookbook := k.GetCookbook(ctx, name)
		cookbooks = append(records, cookbook)

	}

	recipes := k.GetRecipes(ctx)
	
	items, err := k.GetAllItems(ctx)
	if err != nil {
		log.Panicln("error while getting items in exportGenesis:", err.Error())
	}
	
	return GenesisState{Cookbooks: cookbooks, Recipies: recipes, Items: items}
}

	return GenesisState{}
}

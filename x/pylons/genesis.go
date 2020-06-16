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
	Recipes   []types.Recipe
	Items     []types.Item
}

// NewGenesisState returns new genesis state
func NewGenesisState() GenesisState {
	return GenesisState{}
}

// ValidateGenesis do validate genesis
func ValidateGenesis(data GenesisState) error {
	return nil
}

// DefaultGenesisState returns default genesis state
func DefaultGenesisState() GenesisState {
	return GenesisState{
		Cookbooks: []types.Cookbook{},
		Recipes:   []types.Recipe{},
		Items:     []types.Item{},
	}
}

// InitGenesis init genesis for a context
func InitGenesis(ctx sdk.Context, keeper keep.Keeper, data GenesisState) {
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

// ExportGenesis export genesis
func ExportGenesis(ctx sdk.Context, k keep.Keeper) GenesisState {
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

	return GenesisState{Cookbooks: cookbooks, Recipes: recipes, Items: items}
}

package keeper

import (
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetRecipe sets a recipe in the key store
func (keeper Keeper) SetRecipe(ctx sdk.Context, recipe types.Recipe) error {
	if recipe.Sender == "" {
		return errors.New("SetRecipe: the sender cannot be empty")
	}
	return keeper.SetObject(ctx, types.TypeRecipe, recipe.ID, keeper.RecipeKey, recipe)
}

// GetRecipe returns recipe based on UUID
func (keeper Keeper) GetRecipe(ctx sdk.Context, id string) (types.Recipe, error) {
	recipe := types.Recipe{}
	err := keeper.GetObject(ctx, types.TypeRecipe, id, keeper.RecipeKey, &recipe)
	return recipe, err
}

// GetRecipes returns an iterator for all the recipe
func (keeper Keeper) GetRecipes(ctx sdk.Context) []types.Recipe {
	store := ctx.KVStore(keeper.RecipeKey)
	iterator := sdk.KVStorePrefixIterator(store, []byte(""))

	var recipes []types.Recipe
	for ; iterator.Valid(); iterator.Next() {
		var recipe types.Recipe
		mRCP := iterator.Value()
		err := json.Unmarshal(mRCP, &recipe)
		if err != nil {
			// this happens because we have multiple versions of breaking recipes at times
			continue
		}

		recipes = append(recipes, recipe)
	}
	return recipes
}

// GetRecipesByCookbook returns recipes filtered by cookbook
func (keeper Keeper) GetRecipesByCookbook(ctx sdk.Context, cookbookID string) []types.Recipe {
	store := ctx.KVStore(keeper.RecipeKey)
	iterator := sdk.KVStorePrefixIterator(store, []byte(""))
	var recipes []types.Recipe
	for ; iterator.Valid(); iterator.Next() {
		var recipe types.Recipe
		mRCP := iterator.Value()
		err := json.Unmarshal(mRCP, &recipe)
		if err != nil {
			// this happens because we have multiple versions of breaking recipes at times
			continue
		}

		if recipe.CookbookID == cookbookID {
			recipes = append(recipes, recipe)
		}
	}
	return recipes
}

// GetAllRecipesCount returns all recipes count
func (keeper Keeper) GetAllRecipesCount(ctx sdk.Context) int {
	recipes := keeper.GetRecipes(ctx)
	return len(recipes)
}

// HasRecipeWithCookbookID checks if a recipe with the provided id and cookbook id is present or not
func (keeper Keeper) HasRecipeWithCookbookID(ctx sdk.Context, cbID, recipeID string) bool {
	store := ctx.KVStore(keeper.RecipeKey)
	mRecipe := store.Get([]byte(recipeID))
	if mRecipe == nil {
		return false
	}

	recipe := types.Recipe{}

	err := json.Unmarshal(mRecipe, &recipe)
	if err != nil {
		return false
	}

	return recipe.CookbookID == cbID
}

// GetRecipesBySender returns an iterator for recipes created by sender
func (keeper Keeper) GetRecipesBySender(ctx sdk.Context, sender sdk.AccAddress) []types.Recipe {
	store := ctx.KVStore(keeper.RecipeKey)
	iterator := sdk.KVStorePrefixIterator(store, []byte(""))
	var recipes []types.Recipe
	for ; iterator.Valid(); iterator.Next() {
		var recipe types.Recipe
		mRCP := iterator.Value()
		err := json.Unmarshal(mRCP, &recipe)
		if err != nil {
			// this happens because we have multiple versions of breaking recipes at times
			continue
		}

		if recipe.Sender == sender.String() {
			recipes = append(recipes, recipe)
		}
	}
	return recipes
}

// UpdateRecipe is used to update the recipe using the id
func (keeper Keeper) UpdateRecipe(ctx sdk.Context, id string, recipe types.Recipe) error {
	if recipe.Sender == "" {
		return errors.New("UpdateRecipe: the sender cannot be empty")

	}
	return keeper.UpdateObject(ctx, types.TypeRecipe, id, keeper.RecipeKey, recipe)
}

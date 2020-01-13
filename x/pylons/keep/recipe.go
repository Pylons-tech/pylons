package keep

import (
	"encoding/json"
	"errors"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetRecipe sets a recipe in the key store
func (k Keeper) SetRecipe(ctx sdk.Context, recipe types.Recipe) error {
	if recipe.Sender.Empty() {
		return errors.New("SetRecipe: the sender cannot be empty")
	}
	return k.SetObject(ctx, types.TypeRecipe, recipe.ID, k.RecipeKey, recipe)
}

// GetRecipe returns recipe based on UUID
func (k Keeper) GetRecipe(ctx sdk.Context, id string) (types.Recipe, error) {

	recipe := types.Recipe{}
	err := k.GetObject(ctx, types.TypeRecipe, id, k.RecipeKey, &recipe)
	return recipe, err
}

// GetRecipes returns an iterator for all the recipe
func (k Keeper) GetRecipes(ctx sdk.Context) []types.Recipe {
	store := ctx.KVStore(k.RecipeKey)
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

// HasRecipeWithCookbookID checks if a recipe with the provided id and cookbook id is present or not
func (k Keeper) HasRecipeWithCookbookID(ctx sdk.Context, cookbookID, recipeID string) bool {
	store := ctx.KVStore(k.RecipeKey)
	mRecipe := store.Get([]byte(recipeID))
	if mRecipe == nil {
		return false
	}

	recipe := types.Recipe{}

	err := json.Unmarshal(mRecipe, &recipe)
	if err != nil {
		return false
	}

	return recipe.CookbookID == cookbookID
}

// GetRecipesBySender returns an iterator for recipes created by sender
func (k Keeper) GetRecipesBySender(ctx sdk.Context, sender sdk.AccAddress) []types.Recipe {
	store := ctx.KVStore(k.RecipeKey)
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

		if recipe.Sender.Equals(sender) {
			recipes = append(recipes, recipe)
		}
	}
	return recipes
}

// UpdateRecipe is used to update the recipe using the id
func (k Keeper) UpdateRecipe(ctx sdk.Context, id string, recipe types.Recipe) error {
	if recipe.Sender.Empty() {
		return errors.New("UpdateRecipe: the sender cannot be empty")

	}
	return k.UpdateObject(ctx, types.TypeRecipe, id, k.RecipeKey, recipe)
}

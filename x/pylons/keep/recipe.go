package keep

import (
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

// GetRecipesIterator returns an iterator for all the iterator
func (k Keeper) GetRecipesIterator(ctx sdk.Context, sender sdk.AccAddress) sdk.Iterator {
	store := ctx.KVStore(k.RecipeKey)
	return sdk.KVStorePrefixIterator(store, []byte(sender.String()))
}

// UpdateRecipe is used to update the recipe using the id
func (k Keeper) UpdateRecipe(ctx sdk.Context, id string, recipe types.Recipe) error {
	if recipe.Sender.Empty() {
		return errors.New("UpdateRecipe: the sender cannot be empty")

	}
	return k.UpdateObject(ctx, types.TypeRecipe, id, k.RecipeKey, recipe)
}

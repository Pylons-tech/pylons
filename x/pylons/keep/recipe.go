package keep

import (
	"errors"
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetRecipe sets a recipe in the key store
func (k Keeper) SetRecipe(ctx sdk.Context, recipe types.Recipe) error {
	if recipe.Sender.Empty() {
		return errors.New("the sender cannot be empty")
	}
	mr, err := k.Cdc.MarshalBinaryBare(recipe)
	if err != nil {
		return err
	}

	store := ctx.KVStore(k.RecipeKey)
	store.Set([]byte(recipe.ID), mr)
	return nil
}

// GetRecipe returns recipe based on UUID
func (k Keeper) GetRecipe(ctx sdk.Context, id string) (types.Recipe, error) {
	store := ctx.KVStore(k.RecipeKey)

	if !store.Has([]byte(id)) {
		return types.Recipe{}, errors.New("The recipe doesn't exist")
	}

	ur := store.Get([]byte(id))
	var recipe types.Recipe

	k.Cdc.MustUnmarshalBinaryBare(ur, &recipe)
	return recipe, nil
}

// GetRecipiesIterator returns an iterator for all the iterator
func (k Keeper) GetRecipiesIterator(ctx sdk.Context, sender sdk.AccAddress) sdk.Iterator {
	store := ctx.KVStore(k.RecipeKey)
	return sdk.KVStorePrefixIterator(store, []byte(sender.String()))
}

// UpdateRecipe is used to update the recipe using the id
func (k Keeper) UpdateRecipe(ctx sdk.Context, id string, recipe types.Recipe) error {
	if recipe.Sender.Empty() {
		return errors.New("the sender cannot be empty")

	}
	store := ctx.KVStore(k.RecipeKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("the recipe with gid %s does not exist", id)
	}
	mr, err := k.Cdc.MarshalBinaryBare(recipe)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mr)
	return nil
}

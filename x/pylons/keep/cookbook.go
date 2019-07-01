package keep

import (
	"errors"

	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetCookbook sets the cookbook with the name as the key
func (k Keeper) SetCookbook(ctx sdk.Context, cookbook types.Cookbook) error {

	if cookbook.Sender.Empty() {
		return errors.New("the sender cannot be empty")

	}
	mCB, err := k.Cdc.MarshalBinaryBare(cookbook)
	if err != nil {
		return err
	}
	store := ctx.KVStore(k.CookbookKey)
	store.Set([]byte(cookbook.KeyGen()), mCB)
	return nil
}

// GetCookbook returns cookbook based on UUID
func (k Keeper) GetCookbook(ctx sdk.Context, id string) (types.Cookbook, error) {
	store := ctx.KVStore(k.CookbookKey)

	if !store.Has([]byte(id)) {
		return types.Cookbook{}, errors.New("The cookbook doesn't exist")
	}

	uCB := store.Get([]byte(id))
	var cookbook types.Cookbook

	k.Cdc.MustUnmarshalBinaryBare(uCB, &cookbook)
	return cookbook, nil
}

// UpdateCookbook is used to update the cookbook using the id
func (k Keeper) UpdateCookbook(ctx sdk.Context, id string, cookbook types.Cookbook) error {
	if cookbook.Sender.Empty() {
		return errors.New("the sender cannot be empty")

	}
	store := ctx.KVStore(k.CookbookKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("the cookbook with gid %s does not exist", id)
	}
	mCB, err := k.Cdc.MarshalBinaryBare(cookbook)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mCB)
	return nil
}

// GetCookbooksIterator returns an iterator for all the cookbooks
func (k Keeper) GetCookbooksIterator(ctx sdk.Context, sender sdk.AccAddress) sdk.Iterator {
	store := ctx.KVStore(k.CookbookKey)
	return sdk.KVStorePrefixIterator(store, []byte(sender.String()))
}

// DeleteCookbook is used to delete a cookbook based on the id
func (k Keeper) DeleteCookbook(ctx sdk.Context, id string) error {
	store := ctx.KVStore(k.CookbookKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("The cookbook with the id %s doesn't exist", id)
	}
	store.Delete([]byte(id))
	return nil
}

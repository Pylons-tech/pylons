package keep

import (
	"strings"
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// SetCookbook sets the cookbook with the name as the key
func (k Keeper) SetCookbook(ctx sdk.Context, cookbook types.Cookbook) error {
	if cookbook.Sender.Empty() {
		return errors.New("SetCookbook: the sender cannot be empty")
	}

	return k.SetObject(ctx, types.TypeCookbook, cookbook.ID, k.CookbookKey, cookbook)
}

// GetCookbook returns cookbook based on UUID
func (k Keeper) GetCookbook(ctx sdk.Context, id string) (types.Cookbook, error) {
	cookbook := types.Cookbook{}
	err := k.GetObject(ctx, types.TypeCookbook, id, k.CookbookKey, &cookbook)
	return cookbook, err
}

// HasCookbook returns cookbook based on UUID
func (k Keeper) HasCookbook(ctx sdk.Context, id string) bool {
	store := ctx.KVStore(k.CookbookKey)
	return store.Has([]byte(id))
}

// UpdateCookbook is used to update the cookbook using the id
func (k Keeper) UpdateCookbook(ctx sdk.Context, id string, cookbook types.Cookbook) error {
	if cookbook.Sender.Empty() {
		return errors.New("UpdateCookbook: the sender cannot be empty")

	}
	return k.UpdateObject(ctx, types.TypeCookbook, id, k.CookbookKey, cookbook)
}

// GetCookbooksIterator returns an iterator for all the cookbooks
func (k Keeper) GetCookbooksIterator(ctx sdk.Context) sdk.Iterator {
	store := ctx.KVStore(k.CookbookKey)
	return sdk.KVStorePrefixIterator(store, []byte(""))
}

// GetCookbookBySender returns cookbooks created by the sender
func (k Keeper) GetCookbookBySender(ctx sdk.Context, sender sdk.AccAddress) ([]types.Cookbook, error) {

	var cookbooks []types.Cookbook
	iterator := k.GetCookbooksIterator(ctx)
	for ; iterator.Valid(); iterator.Next() {
		var cookbook types.Cookbook
		mCB := iterator.Value()
		err := json.Unmarshal(mCB, &cookbook)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		if strings.Contains(cookbook.Sender.String(), sender.String()) { // considered empty sender
			cookbooks = append(cookbooks, cookbook)
		}
	}

	return cookbooks, nil
}

// GetCookbooks returns all cookbooks
func (k Keeper) GetAllCookbooks(ctx sdk.Context) ([]types.Cookbook, error) {

	var cookbooks []types.Cookbook
	iterator := k.GetCookbooksIterator(ctx)
	for ; iterator.Valid(); iterator.Next() {
		var cookbook types.Cookbook
		mCB := iterator.Value()
		err := json.Unmarshal(mCB, &cookbook)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		cookbooks = append(cookbooks, cookbook)
	}

	return cookbooks, nil
}

// GetCookbookCount returns the cookbook count returns 0 if no cookbook is found
func (k Keeper) GetAllCookbooksCount(ctx sdk.Context) int {
	cookbooks, _ := k.GetAllCookbooks(ctx)
	return len(cookbooks)
}

// DeleteCookbook is used to delete a cookbook based on the id
func (k Keeper) DeleteCookbook(ctx sdk.Context, id string) error {
	return k.DeleteObject(ctx, types.TypeCookbook, id, k.CookbookKey)
}

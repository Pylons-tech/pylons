package keeper

import (
	"encoding/json"
	"errors"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// SetCookbook sets the cookbook with the name as the key
func (keeper Keeper) SetCookbook(ctx sdk.Context, cookbook types.Cookbook) error {
	if cookbook.Sender == "" {
		return errors.New("SetCookbook: the sender cannot be empty")
	}

	return keeper.SetObject(ctx, types.TypeCookbook, cookbook.ID, keeper.CookbookKey, cookbook)
}

// GetCookbook returns cookbook based on UUID
func (keeper Keeper) GetCookbook(ctx sdk.Context, id string) (types.Cookbook, error) {
	cookbook := types.Cookbook{}
	err := keeper.GetObject(ctx, types.TypeCookbook, id, keeper.CookbookKey, &cookbook)
	return cookbook, err
}

// HasCookbook returns cookbook based on UUID
func (keeper Keeper) HasCookbook(ctx sdk.Context, id string) bool {
	store := ctx.KVStore(keeper.CookbookKey)
	return store.Has([]byte(id))
}

// UpdateCookbook is used to update the cookbook using the id
func (keeper Keeper) UpdateCookbook(ctx sdk.Context, id string, cookbook types.Cookbook) error {
	if cookbook.Sender == "" {
		return errors.New("UpdateCookbook: the sender cannot be empty")

	}
	return keeper.UpdateObject(ctx, types.TypeCookbook, id, keeper.CookbookKey, cookbook)
}

// GetCookbooksIterator returns an iterator for all the cookbooks
func (keeper Keeper) GetCookbooksIterator(ctx sdk.Context) sdk.Iterator {
	store := ctx.KVStore(keeper.CookbookKey)
	return sdk.KVStorePrefixIterator(store, []byte(""))
}

// GetCookbooksBySender returns cookbooks created by the sender
func (keeper Keeper) GetCookbooksBySender(ctx sdk.Context, sender sdk.AccAddress) ([]types.Cookbook, error) {
	var cookbooks []types.Cookbook
	iterator := keeper.GetCookbooksIterator(ctx)
	for ; iterator.Valid(); iterator.Next() {
		var cookbook types.Cookbook
		mCB := iterator.Value()
		err := json.Unmarshal(mCB, &cookbook)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		if strings.Contains(cookbook.Sender, sender.String()) { // considered empty sender
			cookbooks = append(cookbooks, cookbook)
		}
	}

	return cookbooks, nil
}

// GetAllCookbooks returns all cookbooks
func (keeper Keeper) GetAllCookbooks(ctx sdk.Context) ([]types.Cookbook, error) {

	var cookbooks []types.Cookbook
	iterator := keeper.GetCookbooksIterator(ctx)
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

// GetAllCookbooksCount returns the cookbook count returns 0 if no cookbook is found
func (keeper Keeper) GetAllCookbooksCount(ctx sdk.Context) int {
	cookbooks, _ := keeper.GetAllCookbooks(ctx)
	return len(cookbooks)
}

// DeleteCookbook is used to delete a cookbook based on the id
func (keeper Keeper) DeleteCookbook(ctx sdk.Context, id string) error {
	return keeper.DeleteObject(ctx, types.TypeCookbook, id, keeper.CookbookKey)
}

package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) AddDenomToCookbook(ctx sdk.Context, cookbookID, denom string) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookCoinDenomKey))
	store := prefix.NewStore(parentStore, types.KeyPrefix(cookbookID))
	byteKey := types.KeyPrefix(denom)
	bz := []byte(denom)
	store.Set(byteKey, bz)
}

func (k Keeper) GetDenomsByCookbook(ctx sdk.Context, cookbookID string) (list []string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookCoinDenomKey))
	iterator := sdk.KVStorePrefixIterator(store, types.KeyPrefix(cookbookID))

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		list = append(list, string(iterator.Value()))
	}

	return
}

func (k Keeper) AddCookbookToDenom(ctx sdk.Context, denom, cookbookID string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CoinDenomCookbookKey))
	byteKey := types.KeyPrefix(denom)
	bz := []byte(cookbookID)
	store.Set(byteKey, bz)
}

func (k Keeper) GetCookbookByDenom(ctx sdk.Context, denom string) (cookbookID string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CoinDenomCookbookKey))
	byteKey := types.KeyPrefix(denom)
	bz := store.Get(byteKey)

	// Count doesn't exist: no element
	if bz == nil {
		return ""
	}

	// Parse bytes
	cookbookID = string(bz)

	return
}

func (k Keeper) addCookbookToAddress(ctx sdk.Context, cookbookID string, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrCookbookKey))
	store := prefix.NewStore(parentStore, addr.Bytes())
	byteKey := types.KeyPrefix(cookbookID)
	bz := []byte(cookbookID)
	store.Set(byteKey, bz)
}

func (k Keeper) getCookbookIDsByAddr(ctx sdk.Context, addr sdk.AccAddress) (list []string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrCookbookKey))
	iterator := sdk.KVStorePrefixIterator(store, addr.Bytes())

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		list = append(list, string(iterator.Value()))
	}

	return
}

// SetCookbook set a specific cookbook in the store from its ID
func (k Keeper) SetCookbook(ctx sdk.Context, cookbook types.Cookbook) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookKey))
	b := k.cdc.MustMarshalBinaryBare(&cookbook)
	store.Set(types.KeyPrefix(cookbook.ID), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)

	addr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
	k.addCookbookToAddress(ctx, cookbook.ID, addr)
}

// GetCookbook returns a cookbook from its ID
func (k Keeper) GetCookbook(ctx sdk.Context, id string) (val types.Cookbook, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookKey))

	b := store.Get(types.KeyPrefix(id))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshalBinaryBare(b, &val)
	return val, true
}

// GetAllCookbook returns all cookbook
func (k Keeper) GetAllCookbook(ctx sdk.Context) (list []types.Cookbook) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Cookbook
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// GetAllCookbookByCreator returns cookbooks owned by a specific creator
func (k Keeper) GetAllCookbookByCreator(ctx sdk.Context, creator sdk.AccAddress) (list []types.Cookbook) {
	cookbookIDs := k.getCookbookIDsByAddr(ctx, creator)

	for _, id := range cookbookIDs {
		cookbook, _ := k.GetCookbook(ctx, id)
		list = append(list, cookbook)
	}

	return
}

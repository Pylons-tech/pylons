package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
)

func (k Keeper) addCookbookToAddress(ctx sdk.Context, cookbookID string, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrCookbookKey))
	store := prefix.NewStore(parentStore, addr.Bytes())
	byteKey := v1beta1.KeyPrefix(cookbookID)
	bz := []byte(cookbookID)
	store.Set(byteKey, bz)
}

func (k Keeper) removeCookbookFromAddress(ctx sdk.Context, cookbookID string, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrCookbookKey))
	store := prefix.NewStore(parentStore, addr.Bytes())
	byteKey := v1beta1.KeyPrefix(cookbookID)
	store.Delete(byteKey)
}

func (k Keeper) getCookbookIdsByAddr(ctx sdk.Context, addr sdk.AccAddress) (list []string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrCookbookKey))
	iterator := sdk.KVStorePrefixIterator(store, addr.Bytes())

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		list = append(list, string(iterator.Value()))
	}

	return
}

// SetCookbook set a specific cookbook in the store from its ID
func (k Keeper) SetCookbook(ctx sdk.Context, cookbook v1beta1.Cookbook) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.CookbookKey))
	b := k.cdc.MustMarshal(&cookbook)
	store.Set(v1beta1.KeyPrefix(cookbook.Id), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)

	addr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
	k.addCookbookToAddress(ctx, cookbook.Id, addr)
}

// UpdateCookbook updates a cookbook removing it from previous owner store
func (k Keeper) UpdateCookbook(ctx sdk.Context, cookbook v1beta1.Cookbook, prevAddr sdk.AccAddress) {
	k.removeCookbookFromAddress(ctx, cookbook.Id, prevAddr)
	k.SetCookbook(ctx, cookbook)
}

// GetCookbook returns a cookbook from its ID
func (k Keeper) GetCookbook(ctx sdk.Context, id string) (val v1beta1.Cookbook, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.CookbookKey))

	b := store.Get(v1beta1.KeyPrefix(id))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetAllCookbook returns all cookbook
func (k Keeper) GetAllCookbook(ctx sdk.Context) (list []v1beta1.Cookbook) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.CookbookKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.Cookbook
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// GetAllCookbookByCreator returns cookbooks owned by a specific creator
func (k Keeper) GetAllCookbookByCreator(ctx sdk.Context, creator sdk.AccAddress) (list []v1beta1.Cookbook) {
	cookbookIds := k.getCookbookIdsByAddr(ctx, creator)

	for _, id := range cookbookIds {
		cookbook, _ := k.GetCookbook(ctx, id)
		list = append(list, cookbook)
	}

	return
}

func (k Keeper) getCookbooksByCreatorPaginated(ctx sdk.Context, creator sdk.AccAddress, pagination *query.PageRequest) ([]v1beta1.Cookbook, *query.PageResponse, error) {
	cookbooks := make([]v1beta1.Cookbook, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrCookbookKey))
	store = prefix.NewStore(store, creator.Bytes())

	pageRes, err := query.Paginate(store, pagination, func(_, value []byte) error {
		id := string(value)
		val, _ := k.GetCookbook(ctx, id)
		cookbooks = append(cookbooks, val)
		return nil
	})
	if err != nil {
		return nil, nil, err
	}

	return cookbooks, pageRes, nil
}

package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetRecipe set a specific recipe in the store from its ID
func (k Keeper) SetExecuteRecipeHis(ctx sdk.Context, history types.RecipeHistory) {
	recipesStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(history.CookbookId+history.RecipeId))
	recipesHistoryStore := prefix.NewStore(recipesStore, types.KeyPrefix(types.RecipeHistoryKey))
	b := k.cdc.MustMarshal(&history)
	recipesHistoryStore.Set(types.KeyPrefix(history.ItemId), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// GetAllExecuteRecipeHis returns all recipe histories
func (k Keeper) GetAllExecuteRecipeHis(ctx sdk.Context, cookbookID string, id string) (list []*types.RecipeHistory) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(cookbookID+id))
	recipesHistoryStore := prefix.NewStore(store, types.KeyPrefix(types.RecipeHistoryKey))
	iterator := sdk.KVStorePrefixIterator(recipesHistoryStore, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.RecipeHistory
		err := k.cdc.Unmarshal(iterator.Value(), &val)
		if err != nil {
			continue
		}
		list = append(list, &val)
	}

	return
}

// SetRecipe set a specific recipe in the store from its ID
func (k Keeper) SetItemHistory(ctx sdk.Context, history types.ItemHistory) {
	recipesStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix((history.CookbookId + history.Id)))
	recipesHistoryStore := prefix.NewStore(recipesStore, types.KeyPrefix(types.ItemHistoryKey))
	b := k.cdc.MustMarshal(&history)
	recipesHistoryStore.Set(types.KeyPrefix(history.To), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// SetRecipe set a specific recipe in the store from its ID
func (k Keeper) GetItemHistory(ctx sdk.Context, cookbookID, id string) (list []*types.ItemHistory) {
	recipesStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix((cookbookID + id)))
	recipesHistoryStore := prefix.NewStore(recipesStore, types.KeyPrefix(types.ItemHistoryKey))
	iterator := sdk.KVStorePrefixIterator(recipesHistoryStore, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.ItemHistory
		err := k.cdc.Unmarshal(iterator.Value(), &val)
		if err != nil {
			continue
		}
		list = append(list, &val)
	}
	return
}

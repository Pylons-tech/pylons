package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetRecipe set a specific recipe in the store from its ID
func (k Keeper) SetExecuteRecipeHis(ctx sdk.Context, history types.RecipeHistory) {
	recipesStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(history.CookbookID+history.RecipeID))
	recipesHistoryStore := prefix.NewStore(recipesStore, types.KeyPrefix(types.RecipeHistoryKey))
	b := k.cdc.MustMarshal(&history)
	recipesHistoryStore.Set(types.KeyPrefix(history.ItemID), b)

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
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, &val)
	}

	return
}

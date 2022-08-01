package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetRecipe set a specific recipe in the store from its ID
func (k Keeper) SetExecuteRecipeHis(ctx sdk.Context, history v1beta1.RecipeHistory) {
	recipesStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(history.CookbookId+history.RecipeId))
	recipesHistoryStore := prefix.NewStore(recipesStore, v1beta1.KeyPrefix(v1beta1.RecipeHistoryKey))
	b := k.cdc.MustMarshal(&history)
	recipesHistoryStore.Set(v1beta1.KeyPrefix(history.ItemId), b)

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// GetAllExecuteRecipeHis returns all recipe histories
func (k Keeper) GetAllExecuteRecipeHis(ctx sdk.Context, cookbookID string, id string) (list []*v1beta1.RecipeHistory) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(cookbookID+id))
	recipesHistoryStore := prefix.NewStore(store, v1beta1.KeyPrefix(v1beta1.RecipeHistoryKey))
	iterator := sdk.KVStorePrefixIterator(recipesHistoryStore, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.RecipeHistory
		err := k.cdc.Unmarshal(iterator.Value(), &val)
		if err != nil {
			continue
		}
		list = append(list, &val)
	}

	return
}

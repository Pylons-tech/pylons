package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListRecipe = "list_recipe"
)

// ListRecipe returns a recipe based on the recipe id
func ListRecipe(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	addr := path[0]
	var recipeList types.RecipeList
	var recipies []types.Recipe
	accAddr, err := sdk.AccAddressFromBech32(addr)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	iterator := keeper.GetRecipiesIterator(ctx, accAddr)

	for ; iterator.Valid(); iterator.Next() {
		var recipe types.Recipe
		mCB := iterator.Value()
		err = keeper.Cdc.UnmarshalBinaryBare(mCB, &recipe)
		if err != nil {
			// this happens because we have multiple versions of breaking recipes at times
			continue
		}

		recipies = append(recipies, recipe)
	}

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	recipeList = types.RecipeList{
		Recipies: recipies,
	}

	cbl, err := keeper.Cdc.MarshalJSON(recipeList)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return cbl, nil
}

package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetRecipe = "get_recipe"
)

// GetRecipe returns a recipe based on the recipe id
func GetRecipe(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	if len(path) == 0 {
		return nil, sdk.ErrInternal("no recipe id is provided in path")
	}
	rcpID := path[0]
	recipe, err := keeper.GetItem(ctx, rcpID)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}
	// if we cannot find the value then it should return an error
	bz, err := keeper.Cdc.MarshalJSON(recipe)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return bz, nil

}

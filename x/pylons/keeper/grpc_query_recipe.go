package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) RecipeAll(c context.Context, req *types.QueryAllRecipeRequest) (*types.QueryAllRecipeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var recipes []*types.Recipe
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	recipeStore := prefix.NewStore(store, types.KeyPrefix(types.RecipeKey))

	pageRes, err := query.Paginate(recipeStore, req.Pagination, func(key []byte, value []byte) error {
		var recipe types.Recipe
		if err := k.cdc.UnmarshalBinaryBare(value, &recipe); err != nil {
			return err
		}

		recipes = append(recipes, &recipe)
		return nil
	})

	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &types.QueryAllRecipeResponse{Recipe: recipes, Pagination: pageRes}, nil
}

func (k Keeper) Recipe(c context.Context, req *types.QueryGetRecipeRequest) (*types.QueryGetRecipeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetRecipe(ctx, req.Index)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetRecipeResponse{Recipe: &val}, nil
}

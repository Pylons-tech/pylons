package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) GetRecipeHistory(goCtx context.Context, req *types.QueryGetRecipeHistoryRequest) (*types.QueryGetRecipeHistoryResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	val := k.GetAllExecuteRecipeHis(ctx, req.GetCookbookId(), req.GetRecipeId())
	if len(val) == 0 {
		return &types.QueryGetRecipeHistoryResponse{History: []*types.RecipeHistory{}}, nil
	}

	return &types.QueryGetRecipeHistoryResponse{History: val}, nil
}

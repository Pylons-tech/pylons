package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) GetRecipeHistory(goCtx context.Context, req *v1beta1.QueryGetRecipeHistoryRequest) (*v1beta1.QueryGetRecipeHistoryResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	val := k.GetAllExecuteRecipeHis(ctx, req.GetCookbookId(), req.GetRecipeId())
	if len(val) == 0 {
		return &v1beta1.QueryGetRecipeHistoryResponse{History: []*v1beta1.RecipeHistory{}}, nil
	}

	return &v1beta1.QueryGetRecipeHistoryResponse{History: val}, nil
}

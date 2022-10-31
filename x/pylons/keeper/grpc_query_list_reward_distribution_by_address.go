package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) ListRewardDistributionByAddress(goCtx context.Context, req *types.QueryListRewardDistributionRequest) (*types.QueryGetRewardHistoryResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(goCtx)

	data := k.GetAllRewardDistribution(ctx, req.Address)
	return &types.QueryGetRewardHistoryResponse{History: data}, nil
}

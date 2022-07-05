package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) GetStripeRefund(goCtx context.Context, req *types.QueryGetStripeRefundRequest) (*types.QueryGetStripeRefundResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	data := k.GetAllStripeRefund(ctx)

	return &types.QueryGetStripeRefundResponse{
		Refunds: data,
	}, nil
}

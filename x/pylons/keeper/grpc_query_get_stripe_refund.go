package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) GetStripeRefund(goCtx context.Context, req *v1beta1.QueryGetStripeRefundRequest) (*v1beta1.QueryGetStripeRefundResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	data := k.GetAllStripeRefund(ctx)

	return &v1beta1.QueryGetStripeRefundResponse{
		Refunds: data,
	}, nil
}

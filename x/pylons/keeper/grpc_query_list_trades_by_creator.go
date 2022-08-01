package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListTradesByCreator(goCtx context.Context, req *v1beta1.QueryListTradesByCreatorRequest) (*v1beta1.QueryListTradesByCreatorResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(req.Creator)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "invalid address")
	}

	trades, pageRes, err := k.GetTradesByCreatorPaginated(ctx, addr, req.Pagination)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "paginate: %v", err)
	}

	return &v1beta1.QueryListTradesByCreatorResponse{
			Trades:     trades,
			Pagination: pageRes,
		},
		nil
}

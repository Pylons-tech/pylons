package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListCoinIssuers(goCtx context.Context, req *types.QueryListCoinIssuersRequest) (*types.QueryListCoinIssuersResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	CoinIssuersList := make([]*types.CoinIssuer, len(k.CoinIssuers(ctx)))

	for i, ci := range k.CoinIssuers(ctx) {
		temp := ci
		CoinIssuersList[i] = &temp
	}

	// TODO: Process the query
	_ = ctx

	return &types.QueryListCoinIssuersResponse{IssuersList: CoinIssuersList}, nil
}

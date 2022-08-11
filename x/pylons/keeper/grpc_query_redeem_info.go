package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) RedeemInfoAll(c context.Context, req *types.QueryAllRedeemInfoRequest) (*types.QueryAllRedeemInfoResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var redeemInfos []types.RedeemInfo
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	redeemInfoStore := prefix.NewStore(store, types.KeyPrefix(types.RedeemInfoKey))

	pageRes, err := query.Paginate(redeemInfoStore, req.Pagination, func(key, value []byte) error {
		var redeemInfo types.RedeemInfo
		if err := k.cdc.Unmarshal(value, &redeemInfo); err != nil {
			return err
		}

		redeemInfos = append(redeemInfos, redeemInfo)
		return nil
	})
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &types.QueryAllRedeemInfoResponse{RedeemInfo: redeemInfos, Pagination: pageRes}, nil
}

func (k Keeper) RedeemInfo(c context.Context, req *types.QueryGetRedeemInfoRequest) (*types.QueryGetRedeemInfoResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetRedeemInfo(ctx, req.Id)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetRedeemInfoResponse{RedeemInfo: val}, nil
}

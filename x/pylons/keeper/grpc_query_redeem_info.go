package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) RedeemInfoAll(c context.Context, req *v1beta1.QueryAllRedeemInfoRequest) (*v1beta1.QueryAllRedeemInfoResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var redeemInfos []v1beta1.RedeemInfo
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	redeemInfoStore := prefix.NewStore(store, v1beta1.KeyPrefix(v1beta1.RedeemInfoKey))

	pageRes, err := query.Paginate(redeemInfoStore, req.Pagination, func(key []byte, value []byte) error {
		var redeemInfo v1beta1.RedeemInfo
		if err := k.cdc.Unmarshal(value, &redeemInfo); err != nil {
			return err
		}

		redeemInfos = append(redeemInfos, redeemInfo)
		return nil
	})
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &v1beta1.QueryAllRedeemInfoResponse{RedeemInfo: redeemInfos, Pagination: pageRes}, nil
}

func (k Keeper) RedeemInfo(c context.Context, req *v1beta1.QueryGetRedeemInfoRequest) (*v1beta1.QueryGetRedeemInfoResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetRedeemInfo(ctx, req.Id)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &v1beta1.QueryGetRedeemInfoResponse{RedeemInfo: val}, nil
}

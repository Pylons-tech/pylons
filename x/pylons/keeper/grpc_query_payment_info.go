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

func (k Keeper) PaymentInfoAll(c context.Context, req *types.QueryAllPaymentInfoRequest) (*types.QueryAllPaymentInfoResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var paymentInfos []types.PaymentInfo
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	paymentInfoStore := prefix.NewStore(store, types.KeyPrefix(types.PaymentInfoKey))

	pageRes, err := query.Paginate(paymentInfoStore, req.Pagination, func(key []byte, value []byte) error {
		var paymentInfo types.PaymentInfo
		if err := k.cdc.Unmarshal(value, &paymentInfo); err != nil {
			return err
		}

		paymentInfos = append(paymentInfos, paymentInfo)
		return nil
	})

	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &types.QueryAllPaymentInfoResponse{PaymentInfo: paymentInfos, Pagination: pageRes}, nil
}

func (k Keeper) PaymentInfo(c context.Context, req *types.QueryGetPaymentInfoRequest) (*types.QueryGetPaymentInfoResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetPaymentInfo(ctx, req.PurchaseID)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetPaymentInfoResponse{PaymentInfo: val}, nil
}

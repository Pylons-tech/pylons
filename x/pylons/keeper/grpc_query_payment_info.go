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

func (k Keeper) PaymentInfoAll(c context.Context, req *v1beta1.QueryAllPaymentInfoRequest) (*v1beta1.QueryAllPaymentInfoResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var paymentInfos []v1beta1.PaymentInfo
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	paymentInfoStore := prefix.NewStore(store, v1beta1.KeyPrefix(v1beta1.PaymentInfoKey))

	pageRes, err := query.Paginate(paymentInfoStore, req.Pagination, func(key []byte, value []byte) error {
		var paymentInfo v1beta1.PaymentInfo
		if err := k.cdc.Unmarshal(value, &paymentInfo); err != nil {
			return err
		}

		paymentInfos = append(paymentInfos, paymentInfo)
		return nil
	})
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &v1beta1.QueryAllPaymentInfoResponse{PaymentInfo: paymentInfos, Pagination: pageRes}, nil
}

func (k Keeper) PaymentInfo(c context.Context, req *v1beta1.QueryGetPaymentInfoRequest) (*v1beta1.QueryGetPaymentInfoResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetPaymentInfo(ctx, req.PurchaseId)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &v1beta1.QueryGetPaymentInfoResponse{PaymentInfo: val}, nil
}

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

func (k Keeper) PaymentRefundAll(c context.Context, req *types.QueryAllPaymentRefundRequest) (*types.QueryAllPaymentRefundResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var paymentRefunds []types.PaymentInfo
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	paymentRefundStore := prefix.NewStore(store, types.KeyPrefix(types.PaymentRefundKey))

	pageRes, err := query.Paginate(paymentRefundStore, req.Pagination, func(key []byte, value []byte) error {
		var paymentRefund types.PaymentInfo
		if err := k.cdc.Unmarshal(value, &paymentRefund); err != nil {
			return err
		}

		paymentRefunds = append(paymentRefunds, paymentRefund)
		return nil
	})
	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &types.QueryAllPaymentRefundResponse{PaymentRefund: paymentRefunds, Pagination: pageRes}, nil
}

func (k Keeper) PaymentRefund(c context.Context, req *types.QueryGetPaymentRefundRequest) (*types.QueryGetPaymentRefundResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetPaymentRefund(ctx, req.PurchaseId)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetPaymentRefundResponse{PaymentRefund: val}, nil
}

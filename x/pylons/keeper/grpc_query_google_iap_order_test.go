package keeper_test

import (
	"strconv"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGoogleIAPOrderQuerySingle(t *testing.T) {
	k, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNGoogleIAPOrder(&k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetGoogleInAppPurchaseOrderRequest
		response *types.QueryGetGoogleInAppPurchaseOrderResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetGoogleInAppPurchaseOrderRequest{PurchaseToken: msgs[0].PurchaseToken},
			response: &types.QueryGetGoogleInAppPurchaseOrderResponse{Order: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetGoogleInAppPurchaseOrderRequest{PurchaseToken: msgs[1].PurchaseToken},
			response: &types.QueryGetGoogleInAppPurchaseOrderResponse{Order: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetGoogleInAppPurchaseOrderRequest{PurchaseToken: strconv.Itoa(len(msgs))},
			err:     sdkerrors.ErrKeyNotFound,
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := k.GoogleInAppPurchaseOrder(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}

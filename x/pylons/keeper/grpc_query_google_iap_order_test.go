package keeper

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

func TestGooglIAPOrderQuerySingle(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNGoogleIAPOrder(&keeper, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetGoogleIAPOrderRequest
		response *types.QueryGetGoogleIAPOrderResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetGoogleIAPOrderRequest{PurchaseToken: msgs[0].PurchaseToken},
			response: &types.QueryGetGoogleIAPOrderResponse{GoogleIAPOrder: &msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetGoogleIAPOrderRequest{PurchaseToken: msgs[1].PurchaseToken},
			response: &types.QueryGetGoogleIAPOrderResponse{GoogleIAPOrder: &msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetGoogleIAPOrderRequest{PurchaseToken: strconv.Itoa(len(msgs))},
			err:     sdkerrors.ErrKeyNotFound,
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := keeper.GoogleIAPOrder(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}

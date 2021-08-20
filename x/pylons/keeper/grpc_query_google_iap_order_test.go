package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestGoogleIAPOrderQuerySingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

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
		suite.Run(tc.desc, func() {
			response, err := k.GoogleInAppPurchaseOrder(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

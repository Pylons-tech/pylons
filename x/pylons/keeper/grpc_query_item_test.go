package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (suite *IntegrationTestSuite) TestItemQuerySingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNItem(k, ctx, 2, true)
	for _, tc := range []struct {
		desc     string
		request  *v1beta1.QueryGetItemRequest
		response *v1beta1.QueryGetItemResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &v1beta1.QueryGetItemRequest{CookbookId: msgs[0].CookbookId, Id: msgs[0].Id},
			response: &v1beta1.QueryGetItemResponse{Item: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &v1beta1.QueryGetItemRequest{CookbookId: msgs[1].CookbookId, Id: msgs[1].Id},
			response: &v1beta1.QueryGetItemResponse{Item: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &v1beta1.QueryGetItemRequest{Id: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.Item(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

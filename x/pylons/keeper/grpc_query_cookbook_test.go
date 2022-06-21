package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestCookbookQuerySingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNCookbook(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetCookbookRequest
		response *types.QueryGetCookbookResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetCookbookRequest{Id: msgs[0].Id},
			response: &types.QueryGetCookbookResponse{Cookbook: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetCookbookRequest{Id: msgs[1].Id},
			response: &types.QueryGetCookbookResponse{Cookbook: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetCookbookRequest{Id: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.Cookbook(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

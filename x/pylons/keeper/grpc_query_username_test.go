package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestUsernameQuerySingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNUsername(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetUsernameRequest
		response *types.QueryGetUsernameResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetUsernameRequest{Account: msgs[0].Creator},
			response: &types.QueryGetUsernameResponse{Username: &msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetUsernameRequest{Account: msgs[1].Creator},
			response: &types.QueryGetUsernameResponse{Username: &msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetUsernameRequest{Account: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.Username(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}


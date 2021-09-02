package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestAccountQuerySingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNPylonsAccount(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetAccountRequest
		response *types.QueryGetAccountResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetAccountRequest{Username: msgs[0].Username},
			response: &types.QueryGetAccountResponse{PylonsAccount: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetAccountRequest{Username: msgs[1].Username},
			response: &types.QueryGetAccountResponse{PylonsAccount: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetAccountRequest{Username: "missing"},
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

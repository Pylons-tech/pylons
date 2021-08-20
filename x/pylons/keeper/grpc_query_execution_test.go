package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestExecutionQuerySingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNExecution(k, ctx, 2)
	msgs = append(msgs, createNPendingExecution(k, ctx, 1)...)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetExecutionRequest
		response *types.QueryGetExecutionResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetExecutionRequest{ID: msgs[0].ID},
			response: &types.QueryGetExecutionResponse{Completed: true, Execution: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetExecutionRequest{ID: msgs[1].ID},
			response: &types.QueryGetExecutionResponse{Completed: true, Execution: msgs[1]},
		},
		{
			desc:     "Pending",
			request:  &types.QueryGetExecutionRequest{ID: msgs[2].ID},
			response: &types.QueryGetExecutionResponse{Completed: false, Execution: msgs[2]},
		},
		{
			desc:    "InvalidKey",
			request: &types.QueryGetExecutionRequest{ID: "not_found"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetExecutionRequest{ID: "90325"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.Execution(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

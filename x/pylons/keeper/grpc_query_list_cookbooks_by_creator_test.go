package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestListCookbooksByCreator() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNCookbookSameCreator(k, ctx, 10)

	requestFunc := func(next []byte, offset, limit uint64, total bool, creator string) *types.QueryListCookbooksByCreatorRequest {
		return &types.QueryListCookbooksByCreatorRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			Creator: creator,
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *types.QueryListCookbooksByCreatorRequest
		response *types.QueryListCookbooksByCreatorResponse
		err      error
	}{
		{
			desc:     "ByOffset",
			request:  requestFunc(nil, 0, 5, false, msgs[0].Creator),
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: msgs[:5]},
		},
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, true, msgs[0].Creator),
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: msgs},
		},
		{
			desc:     "KeyNotFound",
			request:  requestFunc(nil, 0, 0, true, types.GenTestBech32FromString("missing")),
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: []types.Cookbook{}},
		},
		{
			desc:    "InvalidRequest1",
			request: &types.QueryListCookbooksByCreatorRequest{Creator: "invalid"},
			err:     status.Error(codes.InvalidArgument, "invalid address"),
		},
		{
			desc: "InvalidRequest2",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListCookbooksByCreator(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response.Cookbooks, response.Cookbooks)
			}
		})
	}
}

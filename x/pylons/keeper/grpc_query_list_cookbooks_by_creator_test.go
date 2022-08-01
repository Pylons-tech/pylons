package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (suite *IntegrationTestSuite) TestListCookbooksByCreator() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNCookbookForSingleOwner(k, ctx, 10)

	requestFunc := func(next []byte, offset, limit uint64, total bool, creator string) *v1beta1.QueryListCookbooksByCreatorRequest {
		return &v1beta1.QueryListCookbooksByCreatorRequest{
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
		request  *v1beta1.QueryListCookbooksByCreatorRequest
		response *v1beta1.QueryListCookbooksByCreatorResponse
		err      error
	}{
		{
			desc:     "ByOffset",
			request:  requestFunc(nil, 0, 5, false, msgs[0].Creator),
			response: &v1beta1.QueryListCookbooksByCreatorResponse{Cookbooks: msgs[:5]},
		},
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, true, msgs[0].Creator),
			response: &v1beta1.QueryListCookbooksByCreatorResponse{Cookbooks: msgs},
		},
		{
			desc:     "KeyNotFound",
			request:  requestFunc(nil, 0, 0, true, v1beta1.GenTestBech32FromString("missing")),
			response: &v1beta1.QueryListCookbooksByCreatorResponse{Cookbooks: []v1beta1.Cookbook{}},
		},
		{
			desc:    "InvalidRequest1",
			request: &v1beta1.QueryListCookbooksByCreatorRequest{Creator: "invalid"},
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

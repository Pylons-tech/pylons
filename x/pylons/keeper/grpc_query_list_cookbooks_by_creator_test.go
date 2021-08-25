package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestListCookbooksByCreator() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNCookbook(k, ctx, 2)

	for _, tc := range []struct {
		desc     string
		request  *types.QueryListCookbooksByCreatorRequest
		response *types.QueryListCookbooksByCreatorResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryListCookbooksByCreatorRequest{Creator: msgs[0].Creator},
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: []types.Cookbook{msgs[0]}},
		},
		{
			desc:     "Second",
			request:  &types.QueryListCookbooksByCreatorRequest{Creator: msgs[1].Creator},
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: []types.Cookbook{msgs[1]}},
		},
		{
			desc:     "KeyNotFound",
			request:  &types.QueryListCookbooksByCreatorRequest{Creator: types.GenTestBech32FromString("missing")},
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: []types.Cookbook(nil)},
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
				require.Equal(tc.response, response)
			}
		})
	}
}

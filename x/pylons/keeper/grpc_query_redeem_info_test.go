package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestRedeemInfoQuerySingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNRedeemInfo(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetRedeemInfoRequest
		response *types.QueryGetRedeemInfoResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetRedeemInfoRequest{Id: msgs[0].Id},
			response: &types.QueryGetRedeemInfoResponse{RedeemInfo: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetRedeemInfoRequest{Id: msgs[1].Id},
			response: &types.QueryGetRedeemInfoResponse{RedeemInfo: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetRedeemInfoRequest{Id: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.RedeemInfo(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

func (suite *IntegrationTestSuite) TestRedeemInfoQueryPaginated() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNRedeemInfo(k, ctx, 5)

	request := func(next []byte, offset, limit uint64, total bool) *types.QueryAllRedeemInfoRequest {
		return &types.QueryAllRedeemInfoRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
		}
	}
	suite.Run("ByOffset", func() {
		step := 2
		for i := 0; i < len(msgs); i += step {
			resp, err := k.RedeemInfoAll(wctx, request(nil, uint64(i), uint64(step), false))
			require.NoError(err)
			for j := i; j < len(msgs) && j < i+step; j++ {
				require.Equal(msgs[j], resp.RedeemInfo[j-i])
			}
		}
	})
	suite.Run("ByKey", func() {
		step := 2
		var next []byte
		for i := 0; i < len(msgs); i += step {
			resp, err := k.RedeemInfoAll(wctx, request(next, 0, uint64(step), false))
			require.NoError(err)
			for j := i; j < len(msgs) && j < i+step; j++ {
				require.Equal(msgs[j], resp.RedeemInfo[j-i])
			}
			next = resp.Pagination.NextKey
		}
	})
	suite.Run("Total", func() {
		resp, err := k.RedeemInfoAll(wctx, request(nil, 0, 0, true))
		require.NoError(err)
		require.Equal(len(msgs), int(resp.Pagination.Total))
	})
	suite.Run("InvalidRequest", func() {
		_, err := k.RedeemInfoAll(wctx, nil)
		require.ErrorIs(err, status.Error(codes.InvalidArgument, "invalid request"))
	})
}

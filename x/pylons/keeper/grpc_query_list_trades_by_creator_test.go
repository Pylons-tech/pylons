package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (suite *IntegrationTestSuite) TestListTradesByCreator() {
	k := suite.k
	ctx := suite.ctx
	wctx := sdk.WrapSDKContext(ctx)
	require := suite.Require()
	items := createNTradeSameOwner(k, ctx, 10)
	addr1, err := sdk.AccAddressFromBech32(items[0].Creator)
	addr2 := v1beta1.GenTestBech32FromString("dummyaddress")
	require.NoError(err)

	requestFunc := func(next []byte, offset, limit uint64, total bool, creator string) *v1beta1.QueryListTradesByCreatorRequest {
		return &v1beta1.QueryListTradesByCreatorRequest{
			Creator: addr1.String(),
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *v1beta1.QueryListTradesByCreatorRequest
		response *v1beta1.QueryListTradesByCreatorResponse
		err      error
	}{
		{
			desc: "Account with trades",
			request: &v1beta1.QueryListTradesByCreatorRequest{
				Creator:    addr1.String(),
				Pagination: nil,
			},
			response: &v1beta1.QueryListTradesByCreatorResponse{
				Trades:     items,
				Pagination: nil,
			},
		},
		{
			desc: "Account without trades",
			request: &v1beta1.QueryListTradesByCreatorRequest{
				Creator:    addr2,
				Pagination: nil,
			},
			response: &v1beta1.QueryListTradesByCreatorResponse{
				Trades:     []v1beta1.Trade{},
				Pagination: nil,
			},
		},
		{
			desc:    "By Offset",
			request: requestFunc(nil, 0, 5, false, addr1.String()),
			response: &v1beta1.QueryListTradesByCreatorResponse{
				Trades:     items[:5],
				Pagination: nil,
			},
		},
		{
			desc:    "All",
			request: requestFunc(nil, 0, 0, true, addr1.String()),
			response: &v1beta1.QueryListTradesByCreatorResponse{
				Trades:     items,
				Pagination: nil,
			},
		},
		{
			desc: "InvalidAddress",
			request: &v1beta1.QueryListTradesByCreatorRequest{
				Creator:    "dummyaddress",
				Pagination: nil,
			},
			err: status.Error(codes.InvalidArgument, "invalid address"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListTradesByCreator(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				nItems := len(response.Trades)
				nItemsResponse := len(tc.response.Trades)
				require.Equal(nItems, nItemsResponse)
				require.ElementsMatch(tc.response.Trades, response.Trades)
			}
		})
	}
}

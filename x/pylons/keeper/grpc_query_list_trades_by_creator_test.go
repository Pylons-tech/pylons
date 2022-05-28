package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestListTradesByCreator() {

	k := suite.k
	ctx := suite.ctx
	wctx := sdk.WrapSDKContext(ctx)
	require := suite.Require()
	items := createNTradeSameOwner(k, ctx, 10)
	addr1, err := sdk.AccAddressFromBech32(items[0].Creator)
	addr2 := types.GenTestBech32FromString("dummyaddress")
	require.NoError(err)

	requestFunc := func(next []byte, offset, limit uint64, total bool, creator string) *types.QueryListTradesByCreatorRequest {
		return &types.QueryListTradesByCreatorRequest{
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
		request  *types.QueryListTradesByCreatorRequest
		response *types.QueryListTradesByCreatorResponse
		err      error
	}{
		{
			desc: "Account with trades",
			request: &types.QueryListTradesByCreatorRequest{
				Creator:    addr1.String(),
				Pagination: nil,
			},
			response: &types.QueryListTradesByCreatorResponse{
				Trades:     items,
				Pagination: nil,
			},
		},
		{
			desc: "Account without trades",
			request: &types.QueryListTradesByCreatorRequest{
				Creator:    addr2,
				Pagination: nil,
			},
			response: &types.QueryListTradesByCreatorResponse{
				Trades:     []types.Trade{},
				Pagination: nil,
			},
		}, {
			desc:    "By Offset",
			request: requestFunc(nil, 0, 5, false, addr1.String()),
			response: &types.QueryListTradesByCreatorResponse{
				Trades:     items[:5],
				Pagination: nil,
			},
		}, {
			desc:    "All",
			request: requestFunc(nil, 0, 0, true, addr1.String()),
			response: &types.QueryListTradesByCreatorResponse{
				Trades:     items,
				Pagination: nil,
			},
		},
		{
			desc: "InvalidAddress",
			request: &types.QueryListTradesByCreatorRequest{
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

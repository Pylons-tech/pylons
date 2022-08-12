package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestListCompletedExecutionByItem() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNExecutionForSingleItem(k, ctx, 10)

	requestFunc := func(next []byte, offset, limit uint64, total bool, cookbookID, itemID string) *types.QueryListExecutionsByItemRequest {
		return &types.QueryListExecutionsByItemRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			CookbookId: cookbookID,
			ItemId:     itemID,
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *types.QueryListExecutionsByItemRequest
		response *types.QueryListExecutionsByItemResponse
		err      error
	}{
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, false, msgs[0].CookbookId, msgs[0].ItemOutputIds[0]),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: msgs, PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc:     "WithLimit",
			request:  requestFunc(nil, 0, 5, false, msgs[0].CookbookId, msgs[0].ItemOutputIds[0]),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: msgs[:5], PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc:     "NoExecutionsInvalidCookbookId",
			request:  requestFunc(nil, 0, 0, true, "missing", msgs[0].ItemOutputIds[0]),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},

		{
			desc:     "NoExecutionsInvalidItemId",
			request:  requestFunc(nil, 0, 0, true, msgs[0].CookbookId, "missing"),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc:     "InvalidRequest",
			request:  requestFunc(nil, 0, 0, true, "missing", "missing"),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc:     "NilRequest",
			request:  nil,
			response: nil,
			err:      status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListExecutionsByItem(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response.CompletedExecutions, response.CompletedExecutions)
				require.Equal(tc.response.PendingExecutions, response.PendingExecutions)

			}
		})
	}
}

func (suite *IntegrationTestSuite) TestListPendingExecutionByItem() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNPendingExecutionForSingleItem(k, ctx, 10)

	requestFunc := func(next []byte, offset, limit uint64, total bool, cookbookID, itemID string) *types.QueryListExecutionsByItemRequest {
		return &types.QueryListExecutionsByItemRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			CookbookId: cookbookID,
			ItemId:     itemID,
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *types.QueryListExecutionsByItemRequest
		response *types.QueryListExecutionsByItemResponse
		err      error
	}{
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, false, msgs[0].CookbookId, msgs[0].ItemOutputIds[0]),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: msgs, Pagination: nil},
		},
		{
			desc:     "WithLimit",
			request:  requestFunc(nil, 0, 5, false, msgs[0].CookbookId, msgs[0].ItemOutputIds[0]),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: msgs[:5], Pagination: nil},
		},
		{
			desc:     "NoExecutionsInvalidCookbookId",
			request:  requestFunc(nil, 0, 0, true, "missing", msgs[0].ItemOutputIds[0]),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},

		{
			desc:     "NoExecutionsInvalidItemId",
			request:  requestFunc(nil, 0, 0, true, msgs[0].CookbookId, "missing"),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc:     "InvalidRequest",
			request:  requestFunc(nil, 0, 0, true, "missing", "missing"),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc: "InvalidRequest2",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListExecutionsByItem(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response.CompletedExecutions, response.CompletedExecutions)
				require.Equal(tc.response.PendingExecutions, response.PendingExecutions)

			}
		})
	}
}

func (suite *IntegrationTestSuite) TestListAllExecutionByItem() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	pending, completed := createNMixedExecutionForSingleItem(k, ctx, 10)
	cookbookID := pending[0].CookbookId
	itemID := pending[0].ItemOutputIds[0]

	requestFunc := func(next []byte, offset, limit uint64, total bool, cookbookID, itemID string) *types.QueryListExecutionsByItemRequest {
		return &types.QueryListExecutionsByItemRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			CookbookId: cookbookID,
			ItemId:     itemID,
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *types.QueryListExecutionsByItemRequest
		response *types.QueryListExecutionsByItemResponse
		err      error
	}{
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, false, cookbookID, itemID),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: completed, PendingExecutions: pending, Pagination: nil},
		},
		{
			desc:     "NoExecutionsInvalidCookbookId",
			request:  requestFunc(nil, 0, 0, true, "missing", itemID),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},

		{
			desc:     "NoExecutionsInvalidItemId",
			request:  requestFunc(nil, 0, 0, true, cookbookID, "missing"),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc:     "InvalidRequest",
			request:  requestFunc(nil, 0, 0, true, "missing", "missing"),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: []types.Execution{}, PendingExecutions: []types.Execution{}, Pagination: nil},
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListExecutionsByItem(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response.CompletedExecutions, response.CompletedExecutions)
				require.Equal(tc.response.PendingExecutions, response.PendingExecutions)

			}
		})
	}
}

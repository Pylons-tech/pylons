package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
)

func (suite *IntegrationTestSuite) TestListExecutionByItem() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNExecutionForSingleItem(k, ctx, 10)

	requestFunc := func(next []byte, offset, limit uint64, total bool, cookbookID string, itemID string) *types.QueryListExecutionsByItemRequest {
		return &types.QueryListExecutionsByItemRequest {
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			CookbookID: cookbookID,
			ItemID: itemID,
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
			request:  requestFunc(nil, 0, 0, false, msgs[0].CookbookID, msgs[0].ItemOutputIDs[0]),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: msgs, PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc: "WithLimit",
			request:  requestFunc(nil, 0, 5, false, msgs[0].CookbookID,msgs[0].ItemOutputIDs[0]),
			response: &types.QueryListExecutionsByItemResponse{CompletedExecutions: msgs[:5], PendingExecutions: []types.Execution{}, Pagination: nil},
		},
		{
			desc:     "NoExecutionsInvalidCookbookID",
			request:  requestFunc(nil, 0, 0, true, "missing", msgs[0].ItemOutputIDs[0]),
			response: &types.QueryListExecutionsByItemResponse {CompletedExecutions: []types.Execution{},PendingExecutions: []types.Execution{}, Pagination: nil},

		},

		{
			desc:     "NoExecutionsInvalidItemID",
			request:  requestFunc(nil, 0, 0, true, msgs[0].CookbookID, "missing"),
			response: &types.QueryListExecutionsByItemResponse {CompletedExecutions: []types.Execution{},PendingExecutions: []types.Execution{}, Pagination: nil},

		},
		{
			desc:     "InvalidRequest",
			request:  requestFunc(nil, 0, 0, true, "missing", "missing"),
			response: &types.QueryListExecutionsByItemResponse {CompletedExecutions: []types.Execution{},PendingExecutions: []types.Execution{}, Pagination: nil},

		},

	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListExecutionsByItem(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response.CompletedExecutions, response.CompletedExecutions)
				require.Equal(tc.response.PendingExecutions, response.PendingExecutions )

			}
		})
	}
}
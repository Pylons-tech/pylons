package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (suite *IntegrationTestSuite) TestListItemByOwner() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNItemSingleOwner(k, ctx, 10, true)

	requestFunc := func(next []byte, offset, limit uint64, total bool, owner string) *v1beta1.QueryListItemByOwnerRequest {
		return &v1beta1.QueryListItemByOwnerRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			Owner: owner,
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *v1beta1.QueryListItemByOwnerRequest
		response *v1beta1.QueryListItemByOwnerResponse
		err      error
	}{
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, false, msgs[0].Owner),
			response: &v1beta1.QueryListItemByOwnerResponse{Items: msgs, Pagination: nil},
		},
		{
			desc:     "WithLimit",
			request:  requestFunc(nil, 0, 5, false, msgs[0].Owner),
			response: &v1beta1.QueryListItemByOwnerResponse{Items: msgs[:5], Pagination: nil},
		},
		{
			desc:     "NoItemsInvalidOwnerID",
			request:  requestFunc(nil, 0, 0, true, "missing"),
			response: nil,
			err:      status.Error(codes.InvalidArgument, "invalid address"),
		},
		{
			desc: "InvalidRequest2",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListItemByOwner(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response.Items, response.Items)
			}
		})
	}
}

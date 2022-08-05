package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestItemHistory() {
	goCtx := sdk.WrapSDKContext(suite.ctx)
	msgs := createNItem(suite.k, suite.ctx, 1, true)

	for _, tc := range []struct {
		desc string
		req  *types.QueryGetItemRequest
		res  *types.QueryGetItemResponse
		err  error
	}{
		{
			desc: "Invalid request",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
		{
			desc: "Not found - InvalidCookbook",
			req: &types.QueryGetItemRequest{
				CookbookId: "InvalidCookbook",
				Id:         msgs[0].Id,
			},
			res: nil,
			err: status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "Not found - InvalidId",
			req: &types.QueryGetItemRequest{
				CookbookId: msgs[0].CookbookId,
				Id:         "InvalidId",
			},
			res: nil,
			err: status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "Success",
			req: &types.QueryGetItemRequest{
				CookbookId: msgs[0].CookbookId,
				Id:         msgs[0].Id,
			},
			res: &types.QueryGetItemResponse{
				Item: msgs[0],
			},
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			res, err := suite.k.Item(goCtx, tc.req)
			if tc.err != nil {
				suite.Require().ErrorIs(err, tc.err)
			} else {
				suite.Require().Equal(res, tc.res)
			}
		})
	}

}

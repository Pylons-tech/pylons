package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (suite *IntegrationTestSuite) TestTradeQuerySingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNTrade(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *v1beta1.QueryGetTradeRequest
		response *v1beta1.QueryGetTradeResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &v1beta1.QueryGetTradeRequest{Id: msgs[0].Id},
			response: &v1beta1.QueryGetTradeResponse{Trade: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &v1beta1.QueryGetTradeRequest{Id: msgs[1].Id},
			response: &v1beta1.QueryGetTradeResponse{Trade: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &v1beta1.QueryGetTradeRequest{Id: uint64(len(msgs))},
			err:     sdkerrors.ErrKeyNotFound,
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.Trade(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

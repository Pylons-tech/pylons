package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestAddressQueryByUsernameSingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNPylonsAccount(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetAddressByUsernameRequest
		response *types.QueryGetAddressByUsernameResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetAddressByUsernameRequest{Username: msgs[0].Username},
			response: &types.QueryGetAddressByUsernameResponse{Address: types.AccountAddr{Value: msgs[0].AccountAddr}},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetAddressByUsernameRequest{Username: msgs[1].Username},
			response: &types.QueryGetAddressByUsernameResponse{Address: types.AccountAddr{Value: msgs[1].AccountAddr}},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetAddressByUsernameRequest{Username: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.AddressByUsername(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

func (suite *IntegrationTestSuite) TestUsernameQueryByAddressSingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNPylonsAccount(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetUsernameByAddressRequest
		response *types.QueryGetUsernameByAddressResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetUsernameByAddressRequest{Address: msgs[0].AccountAddr},
			response: &types.QueryGetUsernameByAddressResponse{Username: types.Username{Value: msgs[0].Username}},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetUsernameByAddressRequest{Address: msgs[1].AccountAddr},
			response: &types.QueryGetUsernameByAddressResponse{Username: types.Username{Value: msgs[1].Username}},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetUsernameByAddressRequest{Address: "missing"},
			err:     status.Error(codes.InvalidArgument, "invalid address"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.UsernameByAddress(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

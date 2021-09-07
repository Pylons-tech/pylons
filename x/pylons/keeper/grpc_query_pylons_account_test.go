package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestAccountQueryByUsernameSingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNPylonsAccount(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetAccountByUsernameRequest
		response *types.QueryGetAccountByUsernameResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetAccountByUsernameRequest{Username: msgs[0].Username},
			response: &types.QueryGetAccountByUsernameResponse{PylonsAccount: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetAccountByUsernameRequest{Username: msgs[1].Username},
			response: &types.QueryGetAccountByUsernameResponse{PylonsAccount: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetAccountByUsernameRequest{Username: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.PylonsAccountByUsername(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

func (suite *IntegrationTestSuite) TestAccountQueryByAddressSingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNPylonsAccount(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetAccountByAddressRequest
		response *types.QueryGetAccountByAddressResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetAccountByAddressRequest{Address: msgs[0].Account},
			response: &types.QueryGetAccountByAddressResponse{PylonsAccount: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetAccountByAddressRequest{Address: msgs[1].Account},
			response: &types.QueryGetAccountByAddressResponse{PylonsAccount: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetAccountByAddressRequest{Address: "missing"},
			err:     status.Error(codes.InvalidArgument, "invalid address"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.PylonsAccountByAddress(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}

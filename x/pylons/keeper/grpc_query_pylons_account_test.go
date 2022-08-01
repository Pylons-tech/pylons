package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (suite *IntegrationTestSuite) TestAddressQueryByUsernameSingle() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNPylonsAccount(k, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *v1beta1.QueryGetAddressByUsernameRequest
		response *v1beta1.QueryGetAddressByUsernameResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &v1beta1.QueryGetAddressByUsernameRequest{Username: msgs[0].Username},
			response: &v1beta1.QueryGetAddressByUsernameResponse{Address: v1beta1.AccountAddr{Value: msgs[0].AccountAddr}},
		},
		{
			desc:     "Second",
			request:  &v1beta1.QueryGetAddressByUsernameRequest{Username: msgs[1].Username},
			response: &v1beta1.QueryGetAddressByUsernameResponse{Address: v1beta1.AccountAddr{Value: msgs[1].AccountAddr}},
		},
		{
			desc:    "KeyNotFound",
			request: &v1beta1.QueryGetAddressByUsernameRequest{Username: "missing"},
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
		request  *v1beta1.QueryGetUsernameByAddressRequest
		response *v1beta1.QueryGetUsernameByAddressResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &v1beta1.QueryGetUsernameByAddressRequest{Address: msgs[0].AccountAddr},
			response: &v1beta1.QueryGetUsernameByAddressResponse{Username: v1beta1.Username{Value: msgs[0].Username}},
		},
		{
			desc:     "Second",
			request:  &v1beta1.QueryGetUsernameByAddressRequest{Address: msgs[1].AccountAddr},
			response: &v1beta1.QueryGetUsernameByAddressResponse{Username: v1beta1.Username{Value: msgs[1].Username}},
		},
		{
			desc:    "KeyNotFound",
			request: &v1beta1.QueryGetUsernameByAddressRequest{Address: "missing"},
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

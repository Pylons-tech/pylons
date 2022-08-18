package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// Test for ListSignUpByReferee function

// TEST 1
// we create message (type: types.QueryListSignUpByReferee) with default Creator
// check if no error

// TEST 2
// we create nil message (type: types.QueryListSignUpByReferee)
// check if if error is proper

// TEST 3
// we create message (type: types.QueryListSignUpByReferee) with invalid Creator
// check if if error is proper
func (suite *IntegrationTestSuite) TestListSignUpByReferee() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)

	test_Creator := types.GenTestBech32FromString("test")
	items := createNTrade(k, ctx, 1)
	addr, err := sdk.AccAddressFromBech32(items[0].Creator)
	require.NoError(err)

	req := &types.MsgCreateAccount{
		Creator:         items[0].Creator,
		Username:        "test",
		ReferralAddress: items[0].Creator,
	}

	k.SetPylonsReferral(ctx, req.Creator, req.Username, req.ReferralAddress)
	require.NoError(err)

	for _, tc := range []struct {
		desc    string
		request *types.QueryListSignUpByReferee
		err     error
	}{
		{
			desc: "Completed",
			request: &types.QueryListSignUpByReferee{
				Creator: addr.String(),
			},
		},
		{
			desc: "Invalid Request",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
		{
			desc: "Key not found",
			request: &types.QueryListSignUpByReferee{
				Creator: test_Creator,
			},
			err: sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := k.ListSignUpByReferee(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
}

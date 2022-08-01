package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (suite *IntegrationTestSuite) TestCreateAccount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	addr := v1beta1.GenTestBech32List(2)
	v1beta1.UpdateAppCheckFlagTest(v1beta1.FlagTrue)

	for _, tc := range []struct {
		desc    string
		request *v1beta1.MsgCreateAccount
		err     error
	}{
		{
			desc:    "Valid",
			request: &v1beta1.MsgCreateAccount{Creator: addr[0], Username: "testUser", ReferralAddress: ""},
		},
		{
			desc:    "InvalidCreator",
			request: &v1beta1.MsgCreateAccount{Creator: "invalid", Username: "testUser", ReferralAddress: ""},
			err:     sdkerrors.ErrInvalidRequest,
		},
		{
			desc:    "DuplicateUsername",
			request: &v1beta1.MsgCreateAccount{Creator: addr[1], Username: "testUser", ReferralAddress: ""},
			err:     v1beta1.ErrDuplicateUsername,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := srv.CreateAccount(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
	v1beta1.UpdateAppCheckFlagTest(v1beta1.FlagFalse)
}

func (suite *IntegrationTestSuite) TestUpdateAccount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	addr := v1beta1.GenTestBech32List(2)
	v1beta1.UpdateAppCheckFlagTest(v1beta1.FlagTrue)

	request := &v1beta1.MsgCreateAccount{Creator: addr[0], Username: "testUser"}
	_, err := srv.CreateAccount(wctx, request)
	require.NoError(err)

	updateFee := k.UpdateUsernameFee(ctx)
	// need enough balance to update num_tests items
	updateFee.Amount = updateFee.Amount.Mul(sdk.NewInt(int64(1)))
	coinsWithUpdateFee := sdk.NewCoins(updateFee)

	creatorAddr, err := sdk.AccAddressFromBech32(addr[0])
	require.NoError(err)
	err = k.MintCoinsToAddr(ctx, creatorAddr, coinsWithUpdateFee)
	require.NoError(err)

	for _, tc := range []struct {
		desc    string
		request *v1beta1.MsgUpdateAccount
		err     error
	}{
		{
			desc:    "Valid",
			request: &v1beta1.MsgUpdateAccount{Creator: addr[0], Username: "testUserUpdated"},
		},
		{
			desc:    "InvalidCreator",
			request: &v1beta1.MsgUpdateAccount{Creator: "invalid", Username: "testUser"},
			err:     sdkerrors.ErrInvalidRequest,
		},
		{
			desc:    "DuplicateUsername",
			request: &v1beta1.MsgUpdateAccount{Creator: addr[0], Username: "testUserUpdated"},
			err:     v1beta1.ErrDuplicateUsername,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := srv.UpdateAccount(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
	v1beta1.UpdateAppCheckFlagTest(v1beta1.FlagFalse)
}

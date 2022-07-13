package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestCreateAccount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	addr := types.GenTestBech32List(2)
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	for _, tc := range []struct {
		desc    string
		request *types.MsgCreateAccount
		err     error
	}{
		{
			desc:    "Valid",
			request: &types.MsgCreateAccount{Creator: addr[0], Username: "testUser"},
		},
		{
			desc:    "InvalidCreator",
			request: &types.MsgCreateAccount{Creator: "invalid", Username: "testUser"},
			err:     sdkerrors.ErrInvalidRequest,
		},
		{
			desc:    "DuplicateUsername",
			request: &types.MsgCreateAccount{Creator: addr[1], Username: "testUser"},
			err:     types.ErrDuplicateUsername,
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
	types.UpdateAppCheckFlagTest(types.FlagFalse)
}

func (suite *IntegrationTestSuite) TestUpdateAccount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	addr := types.GenTestBech32List(2)
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	request := &types.MsgCreateAccount{Creator: addr[0], Username: "testUser"}
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
		request *types.MsgUpdateAccount
		err     error
	}{
		{
			desc:    "Valid",
			request: &types.MsgUpdateAccount{Creator: addr[0], Username: "testUserUpdated"},
		},
		{
			desc:    "InvalidCreator",
			request: &types.MsgUpdateAccount{Creator: "invalid", Username: "testUser"},
			err:     sdkerrors.ErrInvalidRequest,
		},
		{
			desc:    "DuplicateUsername",
			request: &types.MsgUpdateAccount{Creator: addr[0], Username: "testUserUpdated"},
			err:     types.ErrDuplicateUsername,
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
	types.UpdateAppCheckFlagTest(types.FlagFalse)
}

package keeper_test

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// TODO fix these tests

func (suite *IntegrationTestSuite) TestTradeMsgServerCreate(t *testing.T) {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)

	creator := types.GenTestBech32FromString("creator")
	for i := 0; i < 5; i++ {
		resp, err := srv.CreateTrade(wctx, &types.MsgCreateTrade{Creator: creator})
		require.NoError(err)
		require.Equal(i, int(resp.Id))
	}
}

func (suite *IntegrationTestSuite) TestTradeMsgServerDelete() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)
	creator := types.GenTestBech32FromString("creator")

	for _, tc := range []struct {
		desc    string
		request *types.MsgCancelTrade
		err     error
	}{
		{
			desc:    "Completed",
			request: &types.MsgCancelTrade{Creator: creator},
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgCancelTrade{Creator: "B"},
			err:     sdkerrors.ErrUnauthorized,
		},
		{
			desc:    "KeyNotFound",
			request: &types.MsgCancelTrade{Creator: creator, Id: 10},
			err:     sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := srv.CreateTrade(wctx, &types.MsgCreateTrade{Creator: creator})
			require.NoError(err)
			_, err = srv.CancelTrade(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
}

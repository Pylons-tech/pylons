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
			err:     sdkerrors.ErrInvalidRequest,
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
}

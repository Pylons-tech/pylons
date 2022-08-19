package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (suite *IntegrationTestSuite) TestListSignUpByReferee() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)

	addrString := types.GenTestBech32FromString("test")
	addr, err := sdk.AccAddressFromBech32(addrString)
	require.NoError(err)
	account := &types.UserMap{
		AccountAddr: string(addr),
		Username:    "test",
	}
	k.SetPylonsAccount(ctx, types.AccountAddr{Value: account.AccountAddr}, types.Username{Value: account.Username})
	k.SetPylonsReferral(ctx, account.AccountAddr, account.Username, string(addr))

	for _, tc := range []struct {
		desc    string
		request *types.QueryListSignUpByReferee
		valid   bool
	}{
		{
			desc:    "Invalid request",
			request: nil,
			valid:   false,
		},
		{
			desc: "Not found account",
			request: &types.QueryListSignUpByReferee{
				Creator: "NotFound",
			},
			valid: false,
		},
		{
			desc: "Valid",
			request: &types.QueryListSignUpByReferee{
				Creator: string(addr),
			},
			valid: true,
		},
	} {
		suite.Run(tc.desc, func() {
			_, err = k.ListSignUpByReferee(wctx, tc.request)
			if tc.valid {
				require.NoError(err)
			} else {
				require.Error(err)
			}
		})
	}
}

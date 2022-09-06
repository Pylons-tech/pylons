package cli_test

import (
	"testing"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	bank "github.com/cosmos/cosmos-sdk/x/bank/client/cli"
	"github.com/stretchr/testify/require"
)

func settingPylonsAccount(ctx client.Context, t *testing.T, net *network.Network) (string, string, string) {
	acc := util.GenerateAddressesInKeyring(ctx.Keyring, 2)
	common := util.CommonArgs(acc[0].String(), net)

	usernameReferral := "testReferralUsername"
	usernameTokenReferral := "testUsernameToken"
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	args := []string{}
	args = append(args, usernameReferral, usernameTokenReferral, "")
	args = append(args, common...)

	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
	require.NoError(t, err)

	username := "testUsername"
	usernameToken := "testUsernameToken"
	referralAddress := acc[0].String()
	types.UpdateAppCheckFlagTest(types.FlagTrue)
	common = util.CommonArgs(acc[1].String(), net)

	args = []string{}
	args = append(args, username, usernameToken, referralAddress)
	args = append(args, common...)

	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
	require.NoError(t, err)

	common = util.CommonArgs(net.Validators[0].Address.String(), net)

	args = []string{net.Validators[0].Address.String(), acc[0].String(), "1000node0token"}
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, bank.NewSendTxCmd(), args)
	require.NoError(t, err)

	return acc[1].String(), username, referralAddress
}

func TestCmdListReferralsByAddress(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	address, username, referral := settingPylonsAccount(ctx, t, net)

	for _, tc := range []struct {
		desc      string
		address   string
		username  string
		referral  string
		shouldErr bool
	}{
		{
			desc:      "Valid",
			address:   address,
			username:  username,
			referral:  referral,
			shouldErr: false,
		},
		{
			desc:      "Invalid - referral address",
			address:   address,
			username:  username,
			referral:  "Invalid",
			shouldErr: true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.referral}
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdListReferralsByAddress(), args)
			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryListSignUpByRefereeResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Nil(t, resp.Signup)
			} else {
				require.NoError(t, err)
				var resp types.QueryListSignUpByRefereeResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Signup)
				require.Equal(t, resp.Signup.Address, tc.referral)
				require.Equal(t, resp.Signup.Users[0].Address, tc.address)
				require.Equal(t, resp.Signup.Users[0].Username, tc.username)
			}
		})
	}
}

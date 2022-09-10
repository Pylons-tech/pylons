package cli_test

import (
	"testing"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCmdCreateAccount(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	acc := util.GenerateAddressesInKeyring(ctx.Keyring, 2)

	username := "testUsername"
	token := "app-check_token"
	referralAddress := ""
	common := util.CommonArgs(acc[0].String(), net)

	args := []string{}
	args = append(args, username)
	args = append(args, token)
	args = append(args, referralAddress)
	args = append(args, common...)

	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
	require.NoError(t, err)

	for _, tc := range []struct {
		desc            string
		username        string
		token           string
		referralAddress string
		common          []string
		shouldErr       bool
	}{
		{
			desc:            "Invalid username 1",
			username:        "",
			token:           "app-check-token",
			referralAddress: "",
			common:          util.CommonArgs(acc[1].String(), net),
			shouldErr:       true,
		},
		{
			desc:            "Invalid username 2",
			username:        acc[0].String(),
			token:           "app-check-token",
			referralAddress: "",
			common:          util.CommonArgs(acc[1].String(), net),
			shouldErr:       true,
		},
		{
			desc:            "Duplicate username",
			username:        "testUsername",
			token:           "app-check-token",
			referralAddress: "",
			common:          util.CommonArgs(acc[1].String(), net),
			shouldErr:       true,
		},
		{
			desc:            "Duplicate address",
			username:        "testUsername2",
			token:           "app-check-token",
			referralAddress: "",
			common:          util.CommonArgs(acc[0].String(), net),
			shouldErr:       true,
		},
		{
			desc:            "Invalid referral address",
			username:        "testUsername2",
			token:           "app-check-token",
			referralAddress: "Invalid",
			common:          util.CommonArgs(acc[1].String(), net),
			shouldErr:       true,
		},
		{
			desc:            "Referral address does not have account",
			username:        "testUsername2",
			token:           "app-check-token",
			referralAddress: types.GenTestBech32FromString("RefferalAddress"),
			common:          util.CommonArgs(acc[1].String(), net),
			shouldErr:       true,
		},
		{
			desc:            "Valid 1",
			username:        "testUsername2",
			token:           "app-check-token",
			referralAddress: "",
			common:          util.CommonArgs(acc[1].String(), net),
			shouldErr:       false,
		},
		{
			desc:            "Valid 2",
			username:        "testUsername2",
			token:           "app-check-token",
			referralAddress: acc[0].String(),
			common:          util.CommonArgs(acc[1].String(), net),
			shouldErr:       false,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.username)
			args = append(args, tc.token)
			args = append(args, tc.referralAddress)
			args = append(args, tc.common...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
			if tc.shouldErr {
				var resp sdk.TxResponse
				ctx.Codec.UnmarshalJSON(out.Bytes(), &resp)
				require.NotEqual(t, resp.Code, 0) // failed to execute message
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
			}

		})
	}

}

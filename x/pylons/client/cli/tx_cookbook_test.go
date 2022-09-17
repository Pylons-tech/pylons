package cli_test

import (
	"strconv"
	"testing"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func createAccountInKeyring(ctx client.Context, t *testing.T, net *network.Network, n int) []sdk.AccAddress {
	acc := util.GenerateAddressesInKeyring(ctx.Keyring, 2)

	for i := 0; i < n; i++ {
		common := util.CommonArgs(acc[0].String(), net)
		args := []string{}
		args = append(args, "testUsername"+strconv.Itoa(i))
		args = append(args, "")
		args = append(args, "")
		args = append(args, common...)

		_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
		require.NoError(t, err)
	}

	return acc
}

func TestCmdCreateCookbook(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	types.UpdateAppCheckFlagTest(types.FlagTrue)

	acc := createAccountInKeyring(ctx, t, net, 1)

	common := util.CommonArgs(acc[0].String(), net)

	id := "Identity"
	name := "name"
	desc := "desc"
	dev := "dev"
	version := "v0.0.1"
	email := "test@gmail.com"
	enabled := "true"

	for _, tc := range []struct {
		testDesc   string
		id         string
		name       string
		desc       string
		developer  string
		version    string
		email      string
		enabled    string
		shouldFail bool
	}{

		{
			testDesc:   "Invalid enabled-param",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    version,
			email:      email,
			enabled:    "invalid enable",
			shouldFail: true,
		},
		{
			testDesc:   "Invalid Id",
			id:         "",
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    version,
			email:      email,
			enabled:    enabled,
			shouldFail: true,
		},
		{
			testDesc:   "Name is too short",
			id:         "Identity",
			name:       "aa",
			desc:       desc,
			developer:  dev,
			version:    version,
			email:      email,
			enabled:    enabled,
			shouldFail: true,
		},
		{
			testDesc:   "Description is too short",
			id:         id,
			name:       name,
			desc:       "aa",
			developer:  dev,
			version:    version,
			email:      email,
			enabled:    enabled,
			shouldFail: true,
		},
		{
			testDesc:   "Invalid email",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    version,
			email:      "",
			enabled:    enabled,
			shouldFail: true,
		},
		{
			testDesc:   "Invalid version",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    "",
			email:      email,
			enabled:    enabled,
			shouldFail: true,
		},
		{
			testDesc:   "Valid",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    version,
			email:      email,
			enabled:    enabled,
			shouldFail: false,
		},
		{
			testDesc:   "Duplicate Id",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    version,
			email:      email,
			enabled:    enabled,
			shouldFail: true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.id)
			args = append(args, tc.name)
			args = append(args, tc.desc)
			args = append(args, tc.developer)
			args = append(args, tc.version)
			args = append(args, tc.email)
			args = append(args, tc.enabled)
			args = append(args, common...)

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
			if tc.shouldFail {
				if err != nil { // Error returned from Message validate
					require.Error(t, err)
				} else { // Error returned from Keeper
					var resp sdk.TxResponse
					ctx.Codec.UnmarshalJSON(out.Bytes(), &resp)
					require.NotEqual(t, resp.Code, 0)
				}
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, 0, int(resp.Code))
			}
		})
	}
	types.UpdateAppCheckFlagTest(types.FlagFalse)
}

func TestCmdUpdateCookbook(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	types.UpdateAppCheckFlagTest(types.FlagTrue)

	acc := createAccountInKeyring(ctx, t, net, 2)

	common := util.CommonArgs(acc[0].String(), net)
	args := []string{}

	id := "Identity"
	name := "name"
	desc := "desc"
	dev := "dev"
	version := "v0.0.1"
	email := "test@gmail.com"
	enabled := "true"
	newVersion := "v0.0.2"

	args = append(args, id)
	args = append(args, name)
	args = append(args, desc)
	args = append(args, dev)
	args = append(args, version)
	args = append(args, email)
	args = append(args, enabled)
	args = append(args, common...)

	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	for _, tc := range []struct {
		testDesc   string
		id         string
		name       string
		desc       string
		developer  string
		version    string
		email      string
		enabled    string
		common     []string
		shouldFail bool
	}{

		{
			testDesc:   "Invalid enabled-param",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    newVersion,
			email:      email,
			enabled:    "invalid enable",
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Invalid Id",
			id:         "",
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    newVersion,
			email:      email,
			enabled:    enabled,
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Name is too short",
			id:         id,
			name:       "aa",
			desc:       desc,
			developer:  dev,
			version:    newVersion,
			email:      email,
			enabled:    enabled,
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Description is too short",
			id:         id,
			name:       name,
			desc:       "aa",
			developer:  dev,
			version:    newVersion,
			email:      email,
			enabled:    enabled,
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Invalid email",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    newVersion,
			email:      "",
			enabled:    enabled,
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Invalid version",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    "",
			email:      email,
			enabled:    enabled,
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Identity not found",
			id:         "aaaa",
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    newVersion,
			email:      email,
			enabled:    enabled,
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Invalid creator",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    newVersion,
			email:      email,
			enabled:    enabled,
			common:     util.CommonArgs(acc[1].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Invalid version 2",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    version,
			email:      email,
			enabled:    enabled,
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			testDesc:   "Valid",
			id:         id,
			name:       name,
			desc:       desc,
			developer:  dev,
			version:    newVersion,
			email:      email,
			enabled:    enabled,
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
	} {
		tc := tc
		t.Run(tc.testDesc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.id)
			args = append(args, tc.name)
			args = append(args, tc.desc)
			args = append(args, tc.developer)
			args = append(args, tc.version)
			args = append(args, tc.email)
			args = append(args, tc.enabled)
			args = append(args, tc.common...)

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdUpdateCookbook(), args)
			if tc.shouldFail {
				if err != nil { // Error returned from Message validate
					require.Error(t, err)
				} else { // Error returned from Keeper
					var resp sdk.TxResponse
					ctx.Codec.UnmarshalJSON(out.Bytes(), &resp)
					require.NotEqual(t, resp.Code, 0)
				}
			} else {

				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, 0, int(resp.Code))
			}
		})
	}
	types.UpdateAppCheckFlagTest(types.FlagFalse)
}

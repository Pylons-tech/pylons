package cli_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

func settingUserMapObject(t *testing.T) (*network.Network, *types.UserMap) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))
	accountAddr := types.GenTestBech32List(1)
	userMap := types.UserMap{
		AccountAddr: accountAddr[0],
		Username:    "testUserName",
	}

	state.AccountList = append(state.AccountList, userMap)
	buffer, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buffer
	return network.New(t, cfg), &userMap
}

func TestCmdGetAddressByUsername(t *testing.T) {
	net, userMap := settingUserMapObject(t)
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc      string
		userName  string
		address   string
		shouldErr bool
	}{
		{
			desc:      "Valid",
			userName:  userMap.Username,
			address:   userMap.AccountAddr,
			shouldErr: false,
		},
		{
			desc:      "Invalid UserName",
			userName:  "Invalid",
			address:   userMap.AccountAddr,
			shouldErr: true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.userName}
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdGetAddressByUsername(), args)
			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryGetAddressByUsernameResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Address)
			} else {
				require.NoError(t, err)
				var resp types.QueryGetAddressByUsernameResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Address)
				require.Equal(t, resp.Address.Value, tc.address)
			}
		})
	}
}

func TestCmdGetUsernameByAddress(t *testing.T) {
	net, userMap := settingUserMapObject(t)
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc      string
		userName  string
		address   string
		shouldErr bool
	}{
		{
			desc:      "Valid",
			userName:  userMap.Username,
			address:   userMap.AccountAddr,
			shouldErr: false,
		},
		{
			desc:      "Invalid AccountAddr",
			userName:  userMap.Username,
			address:   "Invalid",
			shouldErr: true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.address}
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdGetUsernameByAddress(), args)
			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryGetUsernameByAddressResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Username)
			} else {
				require.NoError(t, err)
				var resp types.QueryGetUsernameByAddressResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Username)
				require.Equal(t, resp.Username.Value, tc.userName)
			}
		})
	}
}

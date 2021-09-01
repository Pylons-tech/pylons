package cli_test

import (
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	keyringerrors "github.com/99designs/keyring"
	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

func TestCreateAccount(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	for _, tc := range []struct {
		desc     string
		username string
		address  string
		flags    []string
		err      error
		code     uint32
	}{
		{
			desc:     "valid",
			username: "validUser",
			address:  val.Address.String(),
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: nil,
		},
		{
			desc:     "invalidAddress",
			username: "validUser",
			address:  "invalidAddress",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, "invalidAddress"),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: keyringerrors.ErrKeyNotFound,
		},
		{
			desc:     "invalidUsername",
			username: "",
			address:  val.Address.String(),
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: types.ErrInvalidRequestField,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.username}
			args = append(args, tc.flags...)
			_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
			if err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				args = []string{tc.address}
				out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowUsername(), args)
				require.NoError(t, err)
				var resp types.QueryGetUsernameResponse
				require.NoError(t, ctx.JSONMarshaler.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.username, resp.Username.Value)
			}
		})
	}
}

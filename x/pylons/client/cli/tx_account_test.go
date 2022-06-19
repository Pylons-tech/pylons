package cli_test

import (
	"fmt"
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/cosmos/cosmos-sdk/testutil/network"
)

func TestCreateAccount(t *testing.T) {
	config := app.DefaultConfig()
	net := network.New(t, config)
	t.Cleanup(net.Cleanup)

	val := net.Validators[0]
	ctx := val.ClientCtx

	accs := GenerateAddressesInKeyring(val.ClientCtx.Keyring, 2)

	for _, tc := range []struct {
		desc     string
		username string
		flags    []string
		err      error
		code     uint32
	}{
		{
			desc:     "account exists 1",
			username: "validUser",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			desc:     "invalidAddress",
			username: "validUser",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, "invalidAddress"),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: sdkerrors.ErrKeyNotFound,
		},
		{
			desc:     "invalidUsername1",
			username: "",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: types.ErrInvalidRequestField,
		},
		{
			desc:     "invalidUsername2",
			username: val.Address.String(),
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: types.ErrInvalidRequestField,
		},
		{
			desc:     "account exists 2",
			username: "validUser",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			desc:     "no coins addr 1",
			username: "nocoins",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, accs[0].String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: 0,
		},
		{
			desc:     "no coins addr dup username",
			username: "nocoins",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, accs[1].String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: types.ErrDuplicateUsername.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.username}
			args = append(args, tc.flags...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

func TestUpdateAccount(t *testing.T) {
	config := app.DefaultConfig()
	net := network.New(t, config)
	t.Cleanup(net.Cleanup)

	val := net.Validators[0]
	ctx := val.ClientCtx

	accs := GenerateAddressesInKeyring(val.ClientCtx.Keyring, 2)
	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, accs[0].String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	username := "user"

	// create account
	args := []string{username}
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	for _, tc := range []struct {
		desc     string
		username string
		flags    []string
		err      error
		code     uint32
	}{
		{
			desc:     "valid",
			username: "validUpdatedUser",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: 0,
		},
		{
			desc:     "invalidAddress",
			username: "validUser",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, "invalidAddress"),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: sdkerrors.ErrKeyNotFound,
		},
		{
			desc:     "invalidUsername1",
			username: "",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, accs[0].String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: types.ErrInvalidRequestField,
		},
		{
			desc:     "invalidUsername2",
			username: val.Address.String(),
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, accs[0].String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: types.ErrInvalidRequestField,
		},
		{
			desc:     "account not created",
			username: "username1234235409",
			flags: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, accs[1].String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: fmt.Errorf("not found: key not found"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.username}
			args = append(args, tc.flags...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdUpdateAccount(), args)
			if tc.err != nil {
				// require.ErrorIs(t, err, tc.err)
				require.Contains(t, err.Error(), tc.err.Error())
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

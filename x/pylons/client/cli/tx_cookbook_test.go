package cli_test

import (
	"fmt"
	"testing"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

func TestCreateCookbook(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	id := "testID"

	fields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}
	for _, tc := range []struct {
		desc string
		id   string
		args []string
		err  error
		code uint32
	}{
		{
			id:   id,
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id}
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.JSONMarshaler.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

func TestUpdateCookbook(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	id := "testID"

	fields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}
	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}
	args := []string{id}
	args = append(args, fields...)
	args = append(args, common...)
	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	// NOTE:
	// for all valid test cases, the version must be increasing from the previous.
	// all test cases are updating the same cookbook, so the version and other fields
	// will be carried over between tests

	valid := []string{
		"ModifiedCookbookname",
		"DescriptionDescriptionDescription",
		"Modified",
		"v0.0.2",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	disable := []string{
		"ModifiedCookbooknameNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.3",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	invalidVersion := []string{
		"ModifiedCookbooknameNewNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	invalidVersionNoModifications := []string{
		"ModifiedCookbooknameNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	noModifications := []string{
		"ModifiedCookbooknameNew",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"false",
	}

	for _, tc := range []struct {
		desc string
		id   string
		args []string
		code uint32
		err  error
	}{
		{
			desc: "valid",
			id:   id,
			args: append(valid, common...),
			code: 0,
		},
		{
			desc: "disable",
			id:   id,
			args: append(disable, common...),
			code: 0,
		},
		{
			desc: "invalidVersion",
			id:   id,
			args: append(invalidVersion, common...),
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			desc: "invalidNoMods",
			id:   id,
			args: append(invalidVersionNoModifications, common...),
			code: 0,
		},
		{
			desc: "noMods",
			id:   id,
			args: append(noModifications, common...),
			code: 0,
		},
		{
			desc: "key not found",
			id:   "not_found",
			args: append(valid, common...),
			code: sdkerrors.ErrKeyNotFound.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdUpdateCookbook(), args)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.JSONMarshaler.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

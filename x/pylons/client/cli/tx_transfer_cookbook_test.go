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
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestTransferCookbook(t *testing.T) {
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

	addrs := types.GenTestBech32List(1)
	recipient := addrs[0]

	valid := []string{
		recipient,
	}

	invalidAddr := []string{
		"invalid",
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
			err:  nil,
			code: 0,
		},
		{
			desc: "no longer owned",
			id:   id,
			args: append(valid, common...),
			err:  nil,
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			desc: "invalid recipient",
			id:   id,
			args: append(invalidAddr, common...),
			err:  sdkerrors.ErrInvalidAddress,
			code: 0,
		},
		{
			desc: "key not found",
			id:   "not_found",
			args: append(valid, common...),
			err:  nil,
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdTransferCookbook(), args)
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

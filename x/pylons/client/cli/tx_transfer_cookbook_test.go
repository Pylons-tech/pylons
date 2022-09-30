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

func TestCmdTransferCookbook(t *testing.T) {
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
		desc       string
		id         string
		recipient  string
		common     []string
		shouldFail bool
	}{
		{
			desc:       "Invalid Id",
			id:         "",
			recipient:  acc[1].String(),
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			desc:       "Cookbook not found",
			id:         "notFound",
			recipient:  acc[1].String(),
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: true,
		},
		{
			desc:       "Incorrect owner",
			id:         "notFound",
			recipient:  acc[1].String(),
			common:     util.CommonArgs(acc[1].String(), net),
			shouldFail: true,
		},
		{
			desc:       "Valid",
			id:         id,
			recipient:  acc[1].String(),
			common:     util.CommonArgs(acc[0].String(), net),
			shouldFail: false,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.id)
			args = append(args, tc.recipient)
			args = append(args, tc.common...)

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdTransferCookbook(), args)
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

				out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowCookbook(), []string{tc.id})
				var queryResp types.QueryGetCookbookResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &queryResp))
				require.Equal(t, tc.recipient, queryResp.Cookbook.Creator)
			}
		})
	}

	types.UpdateAppCheckFlagTest(types.FlagFalse)
}

package cli_test

import (
	"fmt"
	"testing"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

// TODO complete functionality after ExecuteRecipe is added
func TestSetItemString(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"0.0.1",
		"test@email.com",
		"0",
		"1",
		"true",
	}

	// TODO add fields for recipe to be executed
	rpFields := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"0.0.1",
		"[]",
		"[]",
		"{}",
		"[]",
		"1",
		"true",
		"extraInfo",
	}
	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
	args = []string{cookbookID, recipeID}
	args = append(args, rpFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	for _, tc := range []struct {
		desc string
		id1  string
		id2  string
		args []string
		err  error
		code uint32
	}{
		{
			id1:  cookbookID,
			id2:  recipeID,
			desc: "valid",
			args: common,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{cookbookID, recipeID}
			args = append(args, rpFields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
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

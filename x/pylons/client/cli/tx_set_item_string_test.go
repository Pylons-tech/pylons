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
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
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

	// no IDs for this recipe since is just a "generator" recipe
	itemIDs := "[]"

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

	args = []string{cookbookID, recipeID, itemIDs}
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)

	// TODO GET ITEM ID HERE
	executedItemID := ""

	for _, tc := range []struct {
		desc               string
		mutableStringField string
		mutableStringValue string
		args               []string
		err                error
		code               uint32
	}{
		{
			mutableStringField: "field",
			mutableStringValue: "valueNew",
			desc:               "valid",
			args:               common,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {

			// TODO set item ID from a query
			args := []string{cookbookID, executedItemID}
			args = append(args, tc.mutableStringField, tc.mutableStringValue)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdSetItemString(), args)
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

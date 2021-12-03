package cli_test

import (
	"errors"
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

// TODO add tests for coinInput/coinOutput validation

func TestCreateRecipe(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	cbFields := []string{
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
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	for _, tc := range []struct {
		desc   string
		id1    string
		id2    string
		fields []string
		args   []string
		err    error
		code   uint32
	}{
		{
			id1:  cookbookID,
			id2:  recipeID,
			desc: "valid",
			fields: []string{
				"testRecipeName",
				"DescriptionDescriptionDescriptionDescription",
				"v0.0.1",
				"[[\"10000upylon\",\"10000ustake\"]]",
				"[]",
				"{}",
				"[]",
				"1",
				"{\"denom\": \"upylon\", \"amount\": \"1\"}",
				"true",
				"extraInfo",
			},
			args: common,
		},
		{
			id1:  cookbookID,
			id2:  recipeID,
			desc: "invalid",
			fields: []string{
				"testRecipeNameInvalid",
				"DescriptionDescriptionDescriptionDescriptionInvalid",
				"v0.0.1",
				"10000,10000",
				"[]",
				"{}",
				"[]",
				"1",
				"{\"denom\": \"upylon\", \"amount\": \"1\"}",
				"true",
				"extraInfo",
			},
			args: common,
			err: errors.New("Invalid Coin Input : 10000,10000: invalid character ',' after top-level value"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{cookbookID, recipeID}
			args = append(args, tc.fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
			if tc.err != nil {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

func TestUpdateRecipe(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"true",
	}
	fields := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.1",
		"[]",
		"[]",
		"{}",
		"[]",
		"1",
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
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
	args = append(args, fields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// NOTE:
	// for all valid test cases, the version must be increasing from the previous.
	// all test cases are updating the same recipe, so the version and other fields
	// will be carried over between tests

	valid := []string{
		"ModifiedRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.2",
		"[]",
		"[]",
		"{}",
		"[]",
		"1",
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
		"true",
		"extraInfo",
	}

	// disable is a valid transaction that disables the recipe
	disable := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.3",
		"[]",
		"[]",
		"{}",
		"[]",
		"1",
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
		"false",
		"extraInfo",
	}

	// invalidVersion sets the RecipeVersion to be less than the current version, which is invalid
	invalidVersion := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.0",
		"[]",
		"[]",
		"{}",
		"[]",
		"1",
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
		"false",
		"extraInfo",
	}

	for _, tc := range []struct {
		desc string
		id1  string
		id2  string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			id1:  cookbookID,
			id2:  recipeID,
			args: append(valid, common...),
			err:  nil,
			code: 0,
		},
		{
			desc: "disable",
			id1:  cookbookID,
			id2:  recipeID,
			args: append(disable, common...),
			err:  nil,
			code: 0,
		},
		{
			desc: "invalidVersion",
			id1:  cookbookID,
			id2:  recipeID,
			args: append(invalidVersion, common...),
			err:  nil,
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
		{
			desc: "key not found",
			id1:  "not_found",
			id2:  "not_found",
			args: append(valid, common...),
			code: sdkerrors.ErrKeyNotFound.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id1, tc.id2}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdUpdateRecipe(), args)
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

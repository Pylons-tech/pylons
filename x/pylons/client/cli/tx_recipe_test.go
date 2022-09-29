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

func TestCmdCreateRecipe(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	acc := createAccountInKeyring(ctx, t, net, 2)

	common := util.CommonArgs(acc[0].String(), net)

	args := []string{}

	cookbookId := "cookbookId"
	cookbookName := "cookbookname"
	cookbookDesc := "cookbook desc"
	cookbookDev := "dev"
	cookbookVersion := "v0.0.1"
	cookbookEmail := "test@gmail.com"
	cookbookEnabled := "true"

	args = append(args, cookbookId)
	args = append(args, cookbookName)
	args = append(args, cookbookDesc)
	args = append(args, cookbookDev)
	args = append(args, cookbookVersion)
	args = append(args, cookbookEmail)
	args = append(args, cookbookEnabled)
	args = append(args, common...)

	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	id := "recipeId"
	name := "name"
	desc := "desc"
	version := "v0.0.1"
	coinInputs := "[]"
	itemInputs := "[]"
	entries := "{}"
	outputs := "[]"
	blockInterval := "0"
	costPerBlock := "0test"
	enabled := "false"
	extraInfo := ""

	for _, tc := range []struct {
		testDesc      string
		cookbookId    string
		id            string
		name          string
		desc          string
		version       string
		coinInputs    string
		itemInputs    string
		entries       string
		outputs       string
		blockInterval string
		costPerBlock  string
		enabled       string
		extraInfo     string
		common        []string
		shouldFail    bool
	}{
		{
			testDesc:      "Invalid coinInputs",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    "invalid",
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid itemInputs",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    "invalid",
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid entries",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       "invalid",
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid outputs",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       "invalid",
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid block interval",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: "invalid",
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid cost per block",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  "invalid",
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid enabled",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       "invalid",
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid name",
			cookbookId:    cookbookId,
			id:            id,
			name:          "aa",
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid desc",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          "aa",
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid cookbookId",
			cookbookId:    "****",
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid recipeId",
			cookbookId:    cookbookId,
			id:            "****",
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid version",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       "invalid",
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "BlockInterval less than zero",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: "-1",
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Cookbook not found",
			cookbookId:    "NotFound",
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Incorrect owner",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[1].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Valid",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    false,
		},
		{
			testDesc:      "Duplicate id",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
	} {
		tc := tc
		t.Run(tc.testDesc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.cookbookId)
			args = append(args, tc.id)
			args = append(args, tc.name)
			args = append(args, tc.desc)
			args = append(args, tc.version)
			args = append(args, tc.coinInputs)
			args = append(args, tc.itemInputs)
			args = append(args, tc.entries)
			args = append(args, tc.outputs)
			args = append(args, tc.blockInterval)
			args = append(args, tc.costPerBlock)
			args = append(args, tc.enabled)
			args = append(args, tc.extraInfo)
			args = append(args, tc.common...)

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
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

func TestCmdUpdateRecipe(t *testing.T) {
	net := network.New(t)
	ctx := net.Validators[0].ClientCtx

	acc := createAccountInKeyring(ctx, t, net, 2)

	common := util.CommonArgs(acc[0].String(), net)

	args := []string{}

	cookbookId := "cookbookId"
	cookbookName := "cookbookname"
	cookbookDesc := "cookbook desc"
	cookbookDev := "dev"
	cookbookVersion := "v0.0.1"
	cookbookEmail := "test@gmail.com"
	cookbookEnabled := "true"

	args = append(args, cookbookId)
	args = append(args, cookbookName)
	args = append(args, cookbookDesc)
	args = append(args, cookbookDev)
	args = append(args, cookbookVersion)
	args = append(args, cookbookEmail)
	args = append(args, cookbookEnabled)
	args = append(args, common...)

	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	id := "recipeId"
	name := "name"
	desc := "desc"
	version := "v0.0.1"
	coinInputs := "[]"
	itemInputs := "[]"
	entries := "{}"
	outputs := "[]"
	blockInterval := "0"
	costPerBlock := "0test"
	enabled := "false"
	extraInfo := ""
	newVersion := "v0.0.2"

	args = []string{}
	args = append(args, cookbookId)
	args = append(args, id)
	args = append(args, name)
	args = append(args, desc)
	args = append(args, version)
	args = append(args, coinInputs)
	args = append(args, itemInputs)
	args = append(args, entries)
	args = append(args, outputs)
	args = append(args, blockInterval)
	args = append(args, costPerBlock)
	args = append(args, enabled)
	args = append(args, extraInfo)
	args = append(args, common...)

	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	for _, tc := range []struct {
		testDesc      string
		cookbookId    string
		id            string
		name          string
		desc          string
		version       string
		coinInputs    string
		itemInputs    string
		entries       string
		outputs       string
		blockInterval string
		costPerBlock  string
		enabled       string
		extraInfo     string
		common        []string
		shouldFail    bool
	}{
		{
			testDesc:      "Invalid coinInputs",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    "invalid",
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid itemInputs",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    "invalid",
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid entries",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       "invalid",
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid outputs",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       "invalid",
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid block interval",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: "invalid",
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid cost per block",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  "invalid",
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid enabled",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       "invalid",
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid name",
			cookbookId:    cookbookId,
			id:            id,
			name:          "aa",
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid desc",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          "aa",
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid cookbookId",
			cookbookId:    "****",
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid recipeId",
			cookbookId:    cookbookId,
			id:            "****",
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid version",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       "invalid",
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "BlockInterval less than zero",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: "-1",
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Recipe not found",
			cookbookId:    cookbookId,
			id:            "notFound",
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Invalid version 2",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Cookbook not found",
			cookbookId:    "NotFound",
			id:            id,
			name:          name,
			desc:          desc,
			version:       version,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Incorrect owner",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[1].String(), net),
			shouldFail:    true,
		},
		{
			testDesc:      "Valid",
			cookbookId:    cookbookId,
			id:            id,
			name:          name,
			desc:          desc,
			version:       newVersion,
			coinInputs:    coinInputs,
			itemInputs:    itemInputs,
			entries:       entries,
			outputs:       outputs,
			blockInterval: blockInterval,
			costPerBlock:  costPerBlock,
			enabled:       enabled,
			extraInfo:     extraInfo,
			common:        util.CommonArgs(acc[0].String(), net),
			shouldFail:    false,
		},
	} {
		tc := tc
		t.Run(tc.testDesc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.cookbookId)
			args = append(args, tc.id)
			args = append(args, tc.name)
			args = append(args, tc.desc)
			args = append(args, tc.version)
			args = append(args, tc.coinInputs)
			args = append(args, tc.itemInputs)
			args = append(args, tc.entries)
			args = append(args, tc.outputs)
			args = append(args, tc.blockInterval)
			args = append(args, tc.costPerBlock)
			args = append(args, tc.enabled)
			args = append(args, tc.extraInfo)
			args = append(args, tc.common...)

			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdUpdateRecipe(), args)
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

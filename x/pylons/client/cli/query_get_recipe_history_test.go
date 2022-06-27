package cli_test

import (
	"encoding/json"
	"testing"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/spf13/cast"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGetRecipeHistory(t *testing.T) {
	net, objs, _ := util.NetworkWithRecipeObjectsHistory(t, 2)
	val := net.Validators[0]
	ctx := net.Validators[0].ClientCtx
	address, err := util.GenerateAddressWithAccount(ctx, t, net)
	require.NoError(t, err)
	common := util.CommonArgs(address, net)
	tc := []struct {
		desc       string
		cookbookID string
		recipeID   string
		args       []string
		err        error
		obj        []types.RecipeHistory
	}{
		{
			desc:       "not found",
			cookbookID: "not found",
			recipeID:   "not found",
			err:        status.Error(codes.NotFound, "not found"),
			obj:        []types.RecipeHistory{},
		},
		{
			desc:       "found",
			cookbookID: objs[0].CookbookId,
			recipeID:   objs[0].Id,
			args:       common,
			obj: []types.RecipeHistory{
				{
					CookbookId: objs[0].CookbookId,
					RecipeId:   objs[0].Id,
					Sender:     address,
					SenderName: "user",
					Receiver:   net.Validators[0].Address.String(),
					Amount:     "",
				},
			},
		},
	}
	args := []string{tc[0].cookbookID, tc[0].recipeID}
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdGetRecipeHistory(), args)
	if tc[0].err != nil {
		stat, ok := status.FromError(tc[0].err)
		require.True(t, ok)
		require.ErrorIs(t, stat.Err(), tc[0].err)
	} else {
		require.NoError(t, err)
		var resp types.QueryGetRecipeHistoryResponse
		require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
		require.NotNil(t, resp.History)
		require.Equal(t, len(tc[0].obj), len(resp.History))
	}
	cbFields := []string{
		"testCookbookName",
		"Cookbook for testing demo easel transactions",
		"Pylons Inc",
		"v0.0.1",
		"alex@shmeeload.xyz",
		"true",
	}

	// create a cookbook
	args = []string{tc[1].cookbookID}
	args = append(args, cbFields...)
	args = append(args, util.CommonArgs(val.Address.String(), net)...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
	// create a recipe
	tradePercentage, err := sdk.NewDecFromStr("0.01")
	require.NoError(t, err)
	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{
			{
				Id: "testID",
				Doubles: []types.DoubleParam{
					{
						Key: "Mass",
						WeightRanges: []types.DoubleWeightRange{
							{
								Lower:  sdk.NewDec(50),
								Upper:  sdk.NewDec(100),
								Weight: 1,
							},
						},
						Program: "",
					},
				},
				Longs: nil,
				Strings: []types.StringParam{
					{
						Key:     "testKey",
						Value:   "testValue",
						Program: "",
					},
				},
				MutableStrings:  nil,
				TransferFee:     []sdk.Coin{sdk.NewCoin("upylon", sdk.OneInt())},
				TradePercentage: tradePercentage,
				Quantity:        0,
				AmountMinted:    0,
			},
		},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIds: []string{"testID"},
			Weight:   1,
		},
	})
	require.NoError(t, err)

	// test json unmarshalling of strings
	argsEntries, err := cast.ToStringE(string(entries))
	require.NoError(t, err)
	jsonArgsEntries := types.EntriesList{}
	err = json.Unmarshal([]byte(argsEntries), &jsonArgsEntries)
	require.NoError(t, err)
	argsOutputs, err := cast.ToStringE(string(itemOutputs))
	require.NoError(t, err)
	jsonArgsOutputs := make([]types.WeightedOutputs, 0)
	err = json.Unmarshal([]byte(argsOutputs), &jsonArgsOutputs)
	require.NoError(t, err)
	recipeFields := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.1",
		"[]",
		"[]",
		string(entries),
		string(itemOutputs),
		"0",
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
		"true",
		"extraInfo",
	}
	args = []string{tc[1].cookbookID, tc[1].recipeID}
	args = append(args, recipeFields...)
	args = append(args, util.CommonArgs(val.Address.String(), net)...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	args = []string{tc[1].cookbookID, tc[1].recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, tc[1].args...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)
	args = []string{tc[1].cookbookID, tc[1].recipeID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdGetRecipeHistory(), args)
	if tc[0].err != nil {
		stat, ok := status.FromError(tc[1].err)
		require.True(t, ok)
		require.ErrorIs(t, stat.Err(), tc[1].err)
	} else {
		require.NoError(t, err)
		var resp types.QueryGetRecipeHistoryResponse
		require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
		require.NotNil(t, resp.History)
		require.Equal(t, len(tc[0].obj), len(resp.History))
		require.Equal(t, tc[1].obj[0].Sender, resp.History[0].Sender)
	}
}

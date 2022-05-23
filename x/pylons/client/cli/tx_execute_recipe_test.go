package cli_test

import (
	"encoding/json"
	"strconv"
	"strings"
	"testing"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/spf13/cast"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func GenerateAddress() {

}
func TestExecuteRecipeNoInputOutput(t *testing.T) {

	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	address, err := GenerateAddressWithAccount(ctx, t, net)
	require.NoError(t, err)

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

	tradePercentage, err := sdk.NewDecFromStr("0.01")
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{
			{
				ID: "testID",
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
			EntryIDs: []string{"testID"},
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

	common := CommonArgs(val.Address.String(), net)

	// create cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	// create recipe
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// this recipe can be run infinitely
	// run it 5x in a loop
	common = CommonArgs(address, net)
	for i := 0; i < 5; i++ {
		// create execution
		args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
		args = append(args, common...)
		out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
		require.NoError(t, err)
		var resp sdk.TxResponse
		require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
		require.Equal(t, uint32(0), resp.Code)

		// simulate waiting for later block heights
		height, err := net.LatestHeight()
		targetHeight := height + 1
		// build execID from the execution height
		execID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(i)
		require.NoError(t, err)
		_, err = net.WaitForHeightWithTimeout(targetHeight, 60*time.Second)
		require.NoError(t, err)

		// check the execution
		args = []string{execID}
		out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)
		require.NoError(t, err)
		var execResp types.QueryGetExecutionResponse
		require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &execResp))
		// verify completed
		require.Equal(t, true, execResp.Completed)

		// check the item, itemID is i
		itemID := types.EncodeItemID(uint64(i))
		args = []string{cookbookID, itemID}
		out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
		require.NoError(t, err)
		var itemResp types.QueryGetItemResponse
		require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &itemResp))
		require.Equal(t, cookbookID, itemResp.Item.CookbookID)
		require.Equal(t, height, itemResp.Item.LastUpdate)
	}
}

func TestExecuteRecipeQuantityField(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	address, err := GenerateAddressWithAccount(ctx, t, net)
	require.NoError(t, err)

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"true",
	}

	tradePercentage, err := sdk.NewDecFromStr("0.01")
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{
			{
				ID: "testID",
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
				MutableStrings: []types.StringKeyValue{
					{
						Key:   "testMutKey",
						Value: "testMutValue",
					},
				},
				TransferFee:     []sdk.Coin{sdk.NewCoin("upylon", sdk.OneInt())},
				Quantity:        2, // Set quantity so it can only be executed twice
				TradePercentage: tradePercentage,
			},
		},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"testID"},
			Weight:   1,
		},
	})
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

	common := CommonArgs(val.Address.String(), net)

	// create cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	var resp sdk.TxResponse
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create recipe
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create execution
	commonExec := CommonArgs(address, net)

	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, commonExec...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate waiting for later block heights
	height, err := net.LatestHeight()
	require.NoError(t, err)
	// build execID from the execution height
	execID := strconv.Itoa(int(height)) + "-" + "0"

	_, err = net.WaitForHeightWithTimeout(height+2, 30*time.Second)
	require.NoError(t, err)

	// check the execution
	args = []string{execID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)
	require.NoError(t, err)
	var execResp types.QueryGetExecutionResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is 0 because we know there is only 1 item
	itemID := types.EncodeItemID(0)
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
	require.Equal(t, height, itemResp.Item.LastUpdate)

	// check the recipe to see if the AmountMinted has been updated
	expectedAmountMinted := uint64(1)
	args = []string{cookbookID, recipeID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowRecipe(), args)
	require.NoError(t, err)
	var recipeResp types.QueryGetRecipeResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &recipeResp))
	require.Equal(t, expectedAmountMinted, recipeResp.Recipe.Entries.ItemOutputs[0].AmountMinted)

	// try to execute again
	// the response will be ok
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, commonExec...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// checking
	// simulate waiting for later block heights
	height, err = net.LatestHeight()
	// build execID from the execution height
	execID = strconv.Itoa(int(height+0)) + "-" + "1"
	require.NoError(t, err)
	_, err = net.WaitForHeightWithTimeout(height+1, 30*time.Second)
	require.NoError(t, err)

	// check the execution, Completed should be true now, but the expected item will not have been generated
	args = []string{execID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is 1 because this should be the 2nd item
	itemID = types.EncodeItemID(1)
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	stat, ok := status.FromError(err)
	require.True(t, ok)
	// error will be nil as both of the recipe executed successfully
	require.Nil(t, stat)
}

func TestLimitReachExecuteRecipe(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	address, err := GenerateAddressWithAccount(ctx, t, net)
	require.NoError(t, err)

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"true",
	}

	tradePercentage, err := sdk.NewDecFromStr("0.01")
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{
			{
				ID: "testID",
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
				MutableStrings: []types.StringKeyValue{
					{
						Key:   "testMutKey",
						Value: "testMutValue",
					},
				},
				TransferFee:     []sdk.Coin{sdk.NewCoin("upylon", sdk.OneInt())},
				Quantity:        1, // Set quantity so it can only be executed once
				TradePercentage: tradePercentage,
			},
		},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"testID"},
			Weight:   1,
		},
	})
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

	common := CommonArgs(val.Address.String(), net)

	// create cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	var resp sdk.TxResponse
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create recipe
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create execution
	common = CommonArgs(address, net)
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate waiting for later block heights
	height, err := net.LatestHeight()
	require.NoError(t, err)

	_, err = net.WaitForHeightWithTimeout(height+2, 30*time.Second)
	require.NoError(t, err)

	// recipe should not be executed as max quantity to mint is 1
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(18), resp.Code)

	// check the item, itemID is 1 because this should be the 2nd item
	itemID := types.EncodeItemID(1)
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	stat, ok := status.FromError(err)
	require.True(t, ok)

	require.Contains(t, stat.Err().Error(), status.Error(codes.InvalidArgument, "not found").Error())
}

func TestExecuteUpdatedRecipe(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"
	address, err := GenerateAddressWithAccount(ctx, t, net)
	require.NoError(t, err)
	var resp sdk.TxResponse

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"true",
	}

	tradePercentage, err := sdk.NewDecFromStr("0.01")
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{
			{
				ID: "testID",
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
				MutableStrings: []types.StringKeyValue{
					{
						Key:   "testMutKey",
						Value: "testMutValue",
					},
				},
				TransferFee:     []sdk.Coin{sdk.NewCoin("upylon", sdk.OneInt())},
				Quantity:        0, // Set quantity so it can only be executed once
				TradePercentage: tradePercentage,
				AmountMinted:    0,
			},
		},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"testID"},
			Weight:   1,
		},
	})
	require.NoError(t, err)

	recipeFields := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.1",
		"[]",
		"[]",
		string(entries),
		string(itemOutputs),
		"10", // blockInterval set for a delay so the recipe can be updated
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
		"true",
		"extraInfo",
	}

	common := CommonArgs(val.Address.String(), net)

	// create cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create recipe
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create execution
	commonExec := CommonArgs(address, net)
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, commonExec...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate waiting for later block heights
	height, err := net.LatestHeight()
	require.NoError(t, err)
	// build execID from the execution height
	execID := strconv.Itoa(int(height+10)) + "-" + "0"

	// update the recipe before the recipe execution is completed
	// disable is a valid transaction that disables the recipe
	update := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.2",
		"[]",
		"[]",
		string(entries),
		string(itemOutputs),
		"10",
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
		"true",
		"new extra info",
	}

	// update recipe
	args = []string{cookbookID, recipeID}
	args = append(args, update...)
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdUpdateRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	_, err = net.WaitForHeightWithTimeout(height+10, 60*time.Second)
	require.NoError(t, err)

	// check the execution
	args = []string{execID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)
	require.NoError(t, err)
	var execResp types.QueryGetExecutionResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is 1 because this should be the 2nd item
	// item will not exist since execution did not happen
	itemID := types.EncodeItemID(0)
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	stat, ok := status.FromError(err)
	require.True(t, ok)
	require.Contains(t, stat.Err().Error(), status.Error(codes.InvalidArgument, "not found").Error())
}

func TestExecuteDisableRecipe(t *testing.T) {
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

	tradePercentage, err := sdk.NewDecFromStr("0.01")
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{
			{
				ID: "testID",
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
				MutableStrings: []types.StringKeyValue{
					{
						Key:   "testMutKey",
						Value: "testMutValue",
					},
				},
				TransferFee:     []sdk.Coin{sdk.NewCoin("upylon", sdk.OneInt())},
				Quantity:        0, // Set quantity so it can only be executed once
				TradePercentage: tradePercentage,
				AmountMinted:    0,
			},
		},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"testID"},
			Weight:   1,
		},
	})
	require.NoError(t, err)

	// create disabled recipe
	recipeFields := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.1",
		"[]",
		"[]",
		string(entries),
		string(itemOutputs),
		"0", // blockInterval set for a delay so the recipe can be updated
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
		"false",
		"extraInfo",
	}

	common := CommonArgs(val.Address.String(), net)

	// create cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create recipe
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create execution
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, sdkerrors.ErrInvalidRequest.ABCICode(), resp.Code)
}

func TestExecuteRecipeItemInputOutput(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"
	recipeID2 := "testRecipeID2"

	address, err := GenerateAddressWithAccount(ctx, t, net)
	require.NoError(t, err)
	var resp sdk.TxResponse

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"true",
	}
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID: "itemInputID",
			Doubles: []types.DoubleInputParam{
				{
					Key:      "main",
					MinValue: sdk.NewDec(50),
					MaxValue: sdk.NewDec(100),
				},
			},
			Longs: nil,
			Strings: []types.StringInputParam{
				{
					Key:   "testInput",
					Value: "testVal",
				},
			},
		},
	})
	require.NoError(t, err)

	//itemInputIDs, err := json.Marshal([]string{types.EncodeItemID(0)})

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{
			{
				ID: "testID",
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
				TransferFee:     []sdk.Coin{sdk.NewCoin("pylons", sdk.OneInt())},
				TradePercentage: sdk.SmallestDec(),
				Quantity:        0,
				AmountMinted:    0,
			},
		},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"testID"},
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

	recipeFields2 := []string{
		"testRecipeName",
		"DescriptionDescriptionDescriptionDescription",
		"v0.0.1",
		"[]",
		string(itemInputs),
		string(entries),
		string(itemOutputs),
		"0",
		"{\"denom\": \"upylon\", \"amount\": \"1\"}",
		"true",
		"extraInfo",
	}

	common := CommonArgs(val.Address.String(), net)

	// create cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	// create recipe1
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// create recipe2
	args = []string{cookbookID, recipeID2}
	args = append(args, recipeFields2...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// create execution
	common = CommonArgs(address, net)
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate waiting for later block heights
	height, err := net.LatestHeight()
	targetHeight := height + 1
	// build execID from the execution height
	execID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(0)
	require.NoError(t, err)
	_, err = net.WaitForHeightWithTimeout(targetHeight, 60*time.Second)
	require.NoError(t, err)

	// check the execution
	args = []string{execID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)
	require.NoError(t, err)
	var execResp types.QueryGetExecutionResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is i
	itemID := types.EncodeItemID(uint64(0))
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
	require.Equal(t, height, itemResp.Item.LastUpdate)

}

func TestExecuteRecipeMutableStringField(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	address, err := GenerateAddressWithAccount(ctx, t, net)
	require.NoError(t, err)
	var resp sdk.TxResponse

	cbFields := []string{
		"testCookbookName",
		"DescriptionDescriptionDescription",
		"Developer",
		"v0.0.1",
		"test@email.com",
		"true",
	}

	tradePercentage, err := sdk.NewDecFromStr("0.01")
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{
			{
				ID: "testID",
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
				MutableStrings: []types.StringKeyValue{
					{
						Key:   "testMutKey",
						Value: "testMutValue",
					},
				},
				TransferFee:     []sdk.Coin{sdk.NewCoin("pylons", sdk.OneInt())},
				Quantity:        1, // Set quantity so it can only be executed once
				TradePercentage: tradePercentage,
				AmountMinted:    0,
			},
		},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"testID"},
			Weight:   1,
		},
	})
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
		"{\"denom\": \"node0token\", \"amount\": \"1\"}",
		"true",
		"extraInfo",
	}

	common := CommonArgs(val.Address.String(), net)

	// create cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create recipe
	args = []string{cookbookID, recipeID}
	args = append(args, recipeFields...)
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// create execution
	common = CommonArgs(address, net)
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate waiting for later block heights
	height, err := net.LatestHeight()
	require.NoError(t, err)
	// build execID from the execution height
	execID := strconv.Itoa(int(height)) + "-" + "0"

	_, err = net.WaitForHeightWithTimeout(height+2, 30*time.Second)
	require.NoError(t, err)

	// check the execution
	args = []string{execID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)
	require.NoError(t, err)
	var execResp types.QueryGetExecutionResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is 0 because we know there is only 1 item
	itemID := types.EncodeItemID(0)
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
	require.Equal(t, height, itemResp.Item.LastUpdate)

	// check the recipe to see if the Mutable string is represented properly
	expectedMutableString := []types.StringKeyValue{{Key: "testMutKey", Value: "testMutValue"}}

	args = []string{cookbookID, recipeID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowRecipe(), args)
	require.NoError(t, err)
	var recipeResp types.QueryGetRecipeResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &recipeResp))
	require.Equal(t, expectedMutableString, recipeResp.Recipe.Entries.ItemOutputs[0].MutableStrings)

}

func TestExecuteRecipeNoInputOutputInvalidArgs(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"

	common := CommonArgs(val.Address.String(), net)

	// invalid coininputs index
	args := []string{cookbookID, recipeID, "invalid", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.Error(t, err)
	require.True(t, strings.Contains(err.Error(), strconv.ErrSyntax.Error()))

	// invalid item IDs
	args = []string{cookbookID, recipeID, "0", "", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.True(t, strings.Contains(err.Error(), "unexpected end of JSON input"))

	// invalid cookbookIDLOUD
	args = []string{"1", recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.ErrorIs(t, err, sdkerrors.ErrInvalidRequest)

	// invalid recipeID
	args = []string{cookbookID, "1", "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.ErrorIs(t, err, sdkerrors.ErrInvalidRequest)
}

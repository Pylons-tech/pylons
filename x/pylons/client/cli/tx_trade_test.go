package cli_test

import (
	"encoding/json"
	"fmt"
	"strconv"
	"testing"
	"time"

	"github.com/spf13/cast"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

// TODO test for multiple paymentTokens

func TestCreateTradeNoItemOutput1(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				Coins: sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err := json.Marshal([]types.ItemRef{})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: uint32(0),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

func TestCreateTradeNoItemOutput2(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				sdk.NewCoins(sdk.NewCoin(testIBCDenom, sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin(testIBCDenom, sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err := json.Marshal([]types.ItemRef{})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: sdkerrors.ErrInvalidRequest.ABCICode(), // we are able to validate the trade, but it is invalid at the keeper stage since the node does not own any ibc tokens
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

func TestCreateTradeItemOutput(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	// simulate full execution of recipe to generate an item
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
				TransferFee:     []sdk.Coin{sdk.NewCoin("node0token", sdk.NewInt(1))},
				TradePercentage: tradePercentage,
				Quantity:        0,
				AmountMinted:    0,
				Tradeable:       true,
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

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

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

	// create execution
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
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
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is i
	itemID := types.EncodeItemID(uint64(0))
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
	require.Equal(t, height, itemResp.Item.LastUpdate)

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err = json.Marshal([]types.ItemRef{
		{
			CookbookID: cookbookID,
			ItemID:     itemID,
		},
	})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: uint32(0),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				var resp sdk.TxResponse
				require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
				require.Equal(t, tc.code, resp.Code)
			}
		})
	}
}

func TestCreateTradeItemOutputInvalidCoinInputs1(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	// simulate full execution of recipe to generate an item
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
				TransferFee:     []sdk.Coin{sdk.NewCoin("node0token", sdk.NewInt(1))},
				TradePercentage: tradePercentage,
				Quantity:        0,
				AmountMinted:    0,
				Tradeable:       true,
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

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

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

	// create execution
	args = []string{cookbookID, recipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
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
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is i
	itemID := types.EncodeItemID(uint64(0))
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
	require.Equal(t, height, itemResp.Item.LastUpdate)

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				sdk.NewCoins(sdk.NewCoin("pylons", sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err = json.Marshal([]types.ItemRef{
		{
			CookbookID: cookbookID,
			ItemID:     itemID,
		},
	})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: sdkerrors.ErrInvalidCoins,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
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

func TestCreateTradeItemOutputInvalidCoinInputs2(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	// simulate full execution of recipe to generate an item
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
				TransferFee:     []sdk.Coin{sdk.NewCoin("node0token", sdk.NewInt(1))},
				TradePercentage: tradePercentage,
				Quantity:        0,
				AmountMinted:    0,
				Tradeable:       true,
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

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

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

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10)), sdk.NewCoin("pylons", sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err = json.Marshal([]types.ItemRef{
		{
			CookbookID: cookbookID,
			ItemID:     itemID,
		},
	})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: sdkerrors.ErrInvalidCoins,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
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

func TestCreateTradeItemOutputInvalidCoinInputs3(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	// simulate full execution of recipe to generate an item
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
				TransferFee:     []sdk.Coin{sdk.NewCoin("node0token", sdk.NewInt(1))},
				TradePercentage: tradePercentage,
				Quantity:        0,
				AmountMinted:    0,
				Tradeable:       true,
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

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

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

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10)), sdk.NewCoin(testIBCDenom, sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err = json.Marshal([]types.ItemRef{
		{
			CookbookID: cookbookID,
			ItemID:     itemID,
		},
	})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err: sdkerrors.ErrInvalidCoins,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
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

func TestCreateTradeItemOutputInvalidNonTradable(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	// simulate full execution of recipe to generate an item
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
				TransferFee:     []sdk.Coin{sdk.NewCoin("node0token", sdk.NewInt(1))},
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

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

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

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err = json.Marshal([]types.ItemRef{
		{
			CookbookID: cookbookID,
			ItemID:     itemID,
		},
	})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
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

func TestCreateTradeInvalidCoinOutput(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				sdk.NewCoins(sdk.NewCoin("pylons", sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	// validator does not own any "pylons" coins
	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("pylons", sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err := json.Marshal([]types.ItemRef{})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
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

func TestCreateTradeInvalidItemOutput(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(1))),
			},
		},
	)
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	// validator does not own any "pylons" coins
	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err := json.Marshal([]types.ItemRef{
		{
			CookbookID: "fakeCookbook",
			ItemID:     types.EncodeItemID(113345),
		},
	})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}
	for _, tc := range []struct {
		desc string
		args []string
		err  error
		code uint32
	}{
		{
			desc: "valid",
			args: []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
				fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
			},
			err:  nil,
			code: sdkerrors.ErrInvalidRequest.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := make([]string, 0)
			args = append(args, fields...)
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
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

func TestCancelTrade(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	// no coinInputs
	coinInputs, err := json.Marshal([]types.CoinInput{})
	require.NoError(t, err)

	// expect a dummy item
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID:      "item",
			Doubles: nil,
			Longs:   nil,
			Strings: nil,
		},
	})
	require.NoError(t, err)

	coinOutputs, err := json.Marshal(
		sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10))),
	)
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err := json.Marshal([]types.ItemRef{})
	require.NoError(t, err)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	fields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}
	args := make([]string, 0)
	args = append(args, fields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
	require.NoError(t, err)

	for _, tc := range []struct {
		desc string
		id   string
		args []string
		code uint32
		err  error
	}{
		{
			desc: "valid",
			id:   "0",
			args: common,
		},
		{
			desc: "key not found",
			id:   "1",
			args: common,
			code: sdkerrors.ErrKeyNotFound.ABCICode(),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCancelTrade(), append([]string{tc.id}, tc.args...))
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

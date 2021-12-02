package cli_test

import (
	"encoding/json"
	"fmt"
	"strconv"
	"testing"
	"time"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/spf13/cast"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestSendItems(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"
	executedItemID := "testItemID"
	itemMutableStringField := "itemMutableStringField"
	itemMutableStringValue := "itemMutableStringValue"

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
				ID: executedItemID,
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
						Key:   itemMutableStringField,
						Value: itemMutableStringValue,
					},
				},
				TransferFee:     []sdk.Coin{sdk.NewCoin("node0token", sdk.OneInt())},
				TradePercentage: tradePercentage,
				AmountMinted:    0,
				Quantity:        0,
				Tradeable:       true,
			},
		},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{executedItemID},
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
		"",
		"[]",
		string(entries),
		string(itemOutputs),
		"0",
		"1upylon",
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

	numTests := 1
	executedItemRefs := make([]string, numTests)

	for i := 0; i < numTests; i++ {
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
		execID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(0)
		require.NoError(t, err)
		targetHeight := height + 1
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

		// check the item, itemID is 0
		itemID := types.EncodeItemID(uint64(0))
		args = []string{cookbookID, itemID}
		out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
		require.NoError(t, err)
		var itemResp types.QueryGetItemResponse
		require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &itemResp))
		require.Equal(t, cookbookID, itemResp.Item.CookbookID)
		require.Equal(t, height, itemResp.Item.LastUpdate)

		itemRef := []types.ItemRef{
			{
				CookbookID: cookbookID,
				ItemID:     itemResp.Item.ID,
			},
		}

		jsonRef, err := json.Marshal(itemRef)
		require.NoError(t, err)

		executedItemRefs[i] = string(jsonRef)
	}
	addrs := types.GenTestBech32List(1)

	for _, tc := range []struct {
		desc       string
		cookbookID string
		itemRefs   string
		receiver   string
		args       []string
		err        error
		code       uint32
	}{
		{
			desc:       "valid",
			cookbookID: cookbookID,
			itemRefs:   executedItemRefs[0],
			receiver:   addrs[0],
			args:       common,
			err:        nil,
			code:       0,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.receiver, tc.itemRefs}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdSendItems(), args)
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

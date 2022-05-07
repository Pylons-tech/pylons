package cli_test

import (
	"encoding/json"
	"fmt"
	"strconv"
	"testing"
	"time"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

type tradeSimInfo struct {
	net                  *network.Network
	ctx                  client.Context
	basicTradePercentage sdk.Dec
	err                  error
	traderCommon         []string
	fulfillerCommon      []string
	execCount            int
	itemCount            int
	cookbookID           string
	getCoinRecipeID      string
}

func createGetTestCoinsRecipe(t *testing.T, simInfo *tradeSimInfo) {
	denom := "testCoin"
	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: []types.CoinOutput{{
			ID:   "testCoin",
			Coin: sdk.Coin{Denom: denom, Amount: sdk.NewInt(10000)},
		}},
		ItemOutputs:       nil,
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	outputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"testCoin"},
			Weight:   1,
		},
	})

	// Get Character Recipe
	simInfo.getCoinRecipeID = "getTestCoins"
	getCoinRecipe := []string{
		"TEST-get-coins",
		"Gives an account 10000 testCoin",
		"v0.0.1",
		"[]",
		"[]",
		string(entries),
		string(outputs),
		"0",
		"{\"denom\": \"node0token\", \"amount\": \"1\"}",
		"true",
		"extraInfo",
	}

	// create recipe
	args := []string{simInfo.cookbookID, simInfo.getCoinRecipeID}
	args = append(args, getCoinRecipe...)
	args = append(args, simInfo.traderCommon...)
	_, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
}

func getTestCoins(t *testing.T, simInfo *tradeSimInfo, common []string) {
	// execute recipe
	args := []string{simInfo.cookbookID, simInfo.getCoinRecipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, simInfo.ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate waiting for later block heights
	height, err := simInfo.net.LatestHeight()
	targetHeight := height + 1
	// build execID from the execution height
	execID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(simInfo.execCount)
	simInfo.execCount++
	require.NoError(t, err)
	_, err = simInfo.net.WaitForHeightWithTimeout(targetHeight, 60*time.Second)
	require.NoError(t, err)

	// check the execution
	args = []string{execID}
	out, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdShowExecution(), args)
	require.NoError(t, err)
	var execResp types.QueryGetExecutionResponse
	require.NoError(t, simInfo.ctx.Codec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)
}

func TestFulfillTradeItemForCoins(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	var err error

	accs := GenerateAddressesInKeyring(val.ClientCtx.Keyring, 1)
	trader := accs[0]
	traderUsername := "trader"

	fulFillercommon := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	traderCommon := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, trader.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	cookbookID := "testCookbookID"
	itemRecipeID := "itemRecipeID"

	simInfo := &tradeSimInfo{
		net:                  net,
		ctx:                  val.ClientCtx,
		basicTradePercentage: sdk.Dec{},
		err:                  nil,
		traderCommon:         traderCommon,
		fulfillerCommon:      fulFillercommon,
		execCount:            0,
		itemCount:            0,
		cookbookID:           cookbookID,
	}

	simInfo.basicTradePercentage, err = sdk.NewDecFromStr("0.10")
	require.NoError(t, err)

	// create account for trader
	args := []string{traderUsername}
	args = append(args, simInfo.traderCommon...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate full execution of recipe to generate an item

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

	testDenom, err := types.CookbookDenom(simInfo.cookbookID, "testCoin")
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
				TransferFee:     []sdk.Coin{sdk.NewCoin(testDenom, sdk.NewInt(10))},
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
		"{\"denom\": \"node0token\", \"amount\": \"1\"}",
		"true",
		"extraInfo",
	}

	// create cookbook
	args = []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, simInfo.traderCommon...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	createGetTestCoinsRecipe(t, simInfo)

	// create recipe
	args = []string{cookbookID, itemRecipeID}
	args = append(args, recipeFields...)
	args = append(args, simInfo.traderCommon...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// create execution
	args = []string{cookbookID, itemRecipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, simInfo.traderCommon...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate waiting for later block heights
	height, err := net.LatestHeight()
	targetHeight := height + 1
	// build execID from the execution height
	execID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(simInfo.execCount)
	simInfo.execCount++
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

	// no coinInputs
	coinInputs, err := json.Marshal(
		[]types.CoinInput{
			{
				Coins: sdk.NewCoins(sdk.NewCoin(testDenom, sdk.NewInt(110))),
			},
		},
	)
	require.NoError(t, err)

	// no item input
	itemInputs, err := json.Marshal([]types.ItemInput{})
	require.NoError(t, err)

	// no coinOutputs
	coinOutputs, err := json.Marshal(sdk.Coins{
		// sdk.NewCoin(testDenom, sdk.NewInt(10)),
	})
	require.NoError(t, err)

	// no  item outputs
	itemOutputs, err = json.Marshal([]types.ItemRef{
		{
			CookbookID: cookbookID,
			ItemID:     itemID,
		},
	})
	require.NoError(t, err)

	// get some coins for trader
	getTestCoins(t, simInfo, simInfo.traderCommon)
	getTestCoins(t, simInfo, simInfo.fulfillerCommon)

	// coinInputs, itemInputs, coinOutputs, itemOutputs, extraInfo, flags
	tradeFields := []string{
		string(coinInputs),
		string(itemInputs),
		string(coinOutputs),
		string(itemOutputs),
		"extraInfo",
	}

	// create trade from trader
	args = make([]string, 0)
	args = append(args, tradeFields...)
	args = append(args, simInfo.traderCommon...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateTrade(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// fulfill trade from FULFILLER
	//  pylonsd tx pylons fulfill-trade [id] [coin-inputs-index] [item-ids] [payment-info] [flags]
	tradeID := 0
	coinIndex := 0
	items, err := json.Marshal([]types.ItemRef{})
	require.NoError(t, err)

	fulfillFields := []string{
		fmt.Sprintf("%d", tradeID),
		fmt.Sprintf("%d", coinIndex),
		string(items),
		"[]",
	}

	args = make([]string, 0)
	args = append(args, fulfillFields...)
	args = append(args, simInfo.fulfillerCommon...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdFulfillTrade(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// emsure that item is owned by FULFILLER
	args = make([]string, 0)
	args = append(args, val.Address.String())
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdListItemByOwner(), args)
	var listItemResp types.QueryListItemByOwnerResponse
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &listItemResp))
	require.Equal(t, 1, len(listItemResp.Items))

	args = make([]string, 0)
	args = append(args, trader.String())
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdListItemByOwner(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &listItemResp))
	require.Equal(t, 0, len(listItemResp.Items))
}

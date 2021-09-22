package cli_test

import (
	"encoding/json"
	"fmt"
	"strconv"
	"testing"
	"time"

	"github.com/cosmos/cosmos-sdk/client"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

const (
	cookbookID = "cookbookLOUD"
)

var (
	basicTradePercentage sdk.Dec
	err                  error
	common               []string
	execCount            int = 0
	itemCount            int = 0
)

func TestLOUDBasic(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	basicTradePercentage, err = sdk.NewDecFromStr("0.10")
	require.NoError(t, err)

	common = []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	createCookbook(t, net, ctx)
	createCharacter(t, net, ctx)
	getLOUDCoin(t, net, ctx)
	buyCopperSword(t, net, ctx)
}

func createCookbook(t *testing.T, net *network.Network, ctx client.Context) {

	cbFields := []string{
		"Legend of the Undead Dragon",
		"Cookbook for running pylons recreation of LOUD",
		"Pylons Inc",
		"v0.0.1",
		"alex@shmeeload.xyz",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	// create LOUD cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

}

func createCharacter(t *testing.T, net *network.Network, ctx client.Context) {
	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{{
			ID: "basic_character_lv1",
			Doubles: []types.DoubleParam{{
				Key:          "XP",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "1",
			}},
			Longs: []types.LongParam{{
				Key:          "Level",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "1",
			}, {
				Key:          "GiantKills",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "0",
			}, {
				Key:          "Special",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "0",
			}, {
				Key:          "SpecialDragonKill",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "0",
			}, {
				Key:          "UndeadDragonKill",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "0",
			}},
			Strings: []types.StringParam{{
				Key:     "Description",
				Rate:    sdk.NewDec(1),
				Value:   "Basic Character",
				Program: "",
			}},
			MutableStrings:  nil,
			TransferFee:     nil,
			TradePercentage: basicTradePercentage,
			Tradeable:       true,
		}},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"basic_character_lv1"},
			Weight:   1,
		},
	})

	// Get Character Recipe
	getCharacterRecipeID := "LOUDGetCharacter123125"
	getCharacterRecipe := []string{
		"LOUD-Get-Character-Recipe",
		"Creates a basic character in LOUD",
		"v0.0.1",
		"[]",
		"[]",
		string(entries),
		string(itemOutputs),
		"0",
		"true",
		"extraInfo",
	}

	// create recipe
	args := []string{cookbookID, getCharacterRecipeID}
	args = append(args, getCharacterRecipe...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// execute recipe for character
	args = []string{cookbookID, getCharacterRecipeID, "0", "[]"} // empty list for item-ids since there is no item input
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
	execID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(execCount)
	execCount++
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
	itemID := types.EncodeItemID(uint64(itemCount))
	itemCount++
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
	require.Equal(t, height, itemResp.Item.LastUpdate)
}

func getLOUDCoin(t *testing.T, net *network.Network, ctx client.Context) {
	denom := "loudCoin"
	// require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: []types.CoinOutput{{
			ID:   "loudCoin",
			Coin: sdk.Coin{Denom: denom, Amount: sdk.NewInt(10000)},
		}},
		ItemOutputs:       nil,
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	outputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"loudCoin"},
			Weight:   1,
		},
	})

	// Get Character Recipe
	getLoudCoinRecipeID := "LOUD_Get_Coins103120312"
	getLoudCoinRecipe := []string{
		"LOUD-get-coins",
		"Gives a player 10000 loudCoin",
		"v0.0.1",
		"[]",
		"[]",
		string(entries),
		string(outputs),
		"0",
		"true",
		"extraInfo",
	}

	// create recipe
	args := []string{cookbookID, getLoudCoinRecipeID}
	args = append(args, getLoudCoinRecipe...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// execute recipe for character
	args = []string{cookbookID, getLoudCoinRecipeID, "0", "[]"} // empty list for item-ids since there is no item input
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
	execID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(execCount)
	execCount++
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

	// TODO check balance?
}

func buyCopperSword(t *testing.T, net *network.Network, ctx client.Context) {
	denom, err := types.CookbookDenom(cookbookID, "loudCoin")
	require.NoError(t, err)

	coinInputs, err := json.Marshal([]types.CoinInput{
		{Coins: sdk.NewCoins(sdk.NewCoin(denom, sdk.NewInt(10)))},
	})
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{{
			ID: "copper_sword_lv1",
			Doubles: []types.DoubleParam{{
				Key:          "attack",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "10.0",
			}},
			Longs: []types.LongParam{{
				Key:          "level",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "1",
			}, {
				Key:          "value",
				Rate:         sdk.NewDec(1),
				WeightRanges: nil,
				Program:      "250",
			}},
			Strings: []types.StringParam{{
				Key:     "Name",
				Rate:    sdk.NewDec(1),
				Value:   "Copper Sword",
				Program: "",
			}},
			MutableStrings:  nil,
			TransferFee:     nil,
			TradePercentage: basicTradePercentage,
			Tradeable:       true,
		}},
		ItemModifyOutputs: nil,
	})
	require.NoError(t, err)

	itemOutputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"copper_sword_lv1"},
			Weight:   1,
		},
	})

	// Get Character Recipe
	buyCopperSwordRecipeID := "LOUDGetCharacter123125"
	buyCopperSwordRecipe := []string{
		"LOUD-Get-Character-Recipe",
		"Creates a basic character in LOUD",
		"v0.0.1",
		string(coinInputs),
		"[]",
		string(entries),
		string(itemOutputs),
		"0",
		"true",
		"extraInfo",
	}

	// create recipe
	args := []string{cookbookID, buyCopperSwordRecipeID}
	args = append(args, buyCopperSwordRecipe...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// execute recipe for character
	args = []string{cookbookID, buyCopperSwordRecipeID, "0", "[]"} // empty list for item-ids since there is no item input
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
	execID := strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(execCount)
	execCount++
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
	itemID := types.EncodeItemID(uint64(itemCount))
	itemCount++
	args = []string{cookbookID, itemID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
	require.Equal(t, height, itemResp.Item.LastUpdate)
	fmt.Println(itemResp.Item)
}

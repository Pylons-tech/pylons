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

type loudBasicSim struct {
	net                    *network.Network
	ctx                    client.Context
	basicTradePercentage   sdk.Dec
	err                    error
	common                 []string
	execCount              int
	itemCount              int
	characterID            string
	swordID                string
	getCharacterRecipeID   string
	buyCopperSwordRecipeID string
}

func TestLOUDBasic(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	var err error

	simInfo := &loudBasicSim{
		net:                    net,
		ctx:                    ctx,
		basicTradePercentage:   sdk.Dec{},
		err:                    nil,
		common:                 nil,
		execCount:              0,
		itemCount:              0,
		characterID:            "",
		swordID:                "",
		getCharacterRecipeID:   "",
		buyCopperSwordRecipeID: "",
	}

	simInfo.basicTradePercentage, err = sdk.NewDecFromStr("0.10")
	require.NoError(t, err)

	simInfo.common = []string{

		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	createCookbook(t, simInfo)
	createCharacterRecipe(t, simInfo)
	createCharacter(t, simInfo)
	getLOUDCoin(t, simInfo)
	createBuyCopperSwordRecipe(t, simInfo)
	buyCopperSword(t, simInfo)
	fightWolfWithSword(t, simInfo)
}

func createCookbook(t *testing.T, simInfo *loudBasicSim) {

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
	args = append(args, simInfo.common...)
	_, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
}

func createCharacterRecipe(t *testing.T, simInfo *loudBasicSim) {
	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{{
			ID: "basic_character_lv1",
			Doubles: []types.DoubleParam{{
				Key:          "XP",
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "1",
			}},
			Longs: []types.LongParam{{
				Key:          "level",
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "1",
			}, {
				Key:          "giantKills",
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "0",
			}, {
				Key:          "special",
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "0",
			}, {
				Key:          "specialDragonKill",
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "0",
			}, {
				Key:          "undeadDragonKill",
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "0",
			}},
			Strings: []types.StringParam{
				{
					Key:     "entityType",
					Rate:    sdk.OneDec(),
					Value:   "character",
					Program: "",
				}},
			MutableStrings:  nil,
			TransferFee:     nil,
			TradePercentage: simInfo.basicTradePercentage,
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
	simInfo.getCharacterRecipeID = "LOUDGetCharacter123125"
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
	args := []string{cookbookID, simInfo.getCharacterRecipeID}
	args = append(args, getCharacterRecipe...)
	fmt.Println(args)
	args = append(args, simInfo.common...)
	_, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
}

func createCharacter(t *testing.T, simInfo *loudBasicSim) {
	// execute recipe for character
	args := []string{cookbookID, simInfo.getCharacterRecipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, simInfo.common...)
	out, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
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
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is i
	simInfo.characterID = types.EncodeItemID(uint64(simInfo.itemCount))
	simInfo.itemCount++
	args = []string{cookbookID, simInfo.characterID}
	out, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
}

func getLOUDCoin(t *testing.T, simInfo *loudBasicSim) {
	denom := "loudCoin"
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
	args = append(args, simInfo.common...)
	_, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// execute recipe for character
	args = []string{cookbookID, getLoudCoinRecipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, simInfo.common...)
	out, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
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
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// TODO check balance?
}

func createBuyCopperSwordRecipe(t *testing.T, simInfo *loudBasicSim) {
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
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "10.0",
			}},
			Longs: []types.LongParam{{
				Key:          "level",
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "1",
			}, {
				Key:          "value",
				Rate:         sdk.OneDec(),
				WeightRanges: nil,
				Program:      "250",
			}},
			Strings: []types.StringParam{{
				Key:     "name",
				Rate:    sdk.OneDec(),
				Value:   "Copper Sword",
				Program: "",
			}},
			MutableStrings:  nil,
			TransferFee:     nil,
			TradePercentage: simInfo.basicTradePercentage,
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
	simInfo.buyCopperSwordRecipeID = "LOUDbuyCopperSword123125"
	buyCopperSwordRecipe := []string{
		"LOUD-Buy-Copper-Sword",
		"Purchases a copper sword for loudCoin",
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
	args := []string{cookbookID, simInfo.buyCopperSwordRecipeID}
	args = append(args, buyCopperSwordRecipe...)
	args = append(args, simInfo.common...)
	_, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
}

func buyCopperSword(t *testing.T, simInfo *loudBasicSim) {
	// execute recipe for character
	args := []string{cookbookID, simInfo.buyCopperSwordRecipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
	args = append(args, simInfo.common...)
	out, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	var resp sdk.TxResponse
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
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
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is i
	simInfo.swordID = types.EncodeItemID(uint64(simInfo.itemCount))
	simInfo.itemCount++
	args = []string{cookbookID, simInfo.swordID}
	out, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
}

func fightWolfWithSword(t *testing.T, simInfo *loudBasicSim) {
	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID: "character",
			Doubles: []types.DoubleInputParam{
				{
					Key:      "XP",
					MinValue: sdk.NewDec(1),
					MaxValue: sdk.NewDec(10000000),
				},
			},
			Longs: []types.LongInputParam{
				{
					Key:      "level",
					MinValue: 1,
					MaxValue: 10000000,
				},
			},
			Strings: []types.StringInputParam{
				{
					Key:   "entityType",
					Value: "character",
				},
			},
			Conditions: types.ConditionList{},
		},
		{
			ID: "sword",
			Doubles: []types.DoubleInputParam{
				{
					Key:      "attack",
					MinValue: sdk.NewDec(1),
					MaxValue: sdk.NewDec(10000000),
				},
			},
			Longs: []types.LongInputParam{
				{
					Key:      "level",
					MinValue: 1,
					MaxValue: 10000000,
				},
			},
			Strings:    nil,
			Conditions: types.ConditionList{},
		},
	})

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: []types.CoinOutput{
			{
				ID:      "coin_reward",
				Coin:    sdk.Coin{Denom: "loudCoin", Amount: sdk.NewInt(10)},
				Program: "",
			},
		},
		ItemOutputs: []types.ItemOutput{
			{
				ID: "wolf_tail",
				Doubles: []types.DoubleParam{
					{
						Key:          "attack",
						Rate:         sdk.NewDec(1),
						WeightRanges: nil,
						Program:      "0.0",
					},
				},
				Longs: []types.LongParam{
					{
						Key:          "level",
						Rate:         sdk.NewDec(1),
						WeightRanges: nil,
						Program:      "1",
					},
					{
						Key:          "value",
						Rate:         sdk.NewDec(1),
						WeightRanges: nil,
						Program:      "140",
					},
				},
				Strings: []types.StringParam{
					{
						Key:     "name",
						Rate:    sdk.NewDec(1),
						Value:   "Wolf Tail",
						Program: "",
					},
				},
				MutableStrings:  nil,
				TransferFee:     nil,
				TradePercentage: simInfo.basicTradePercentage,
				Quantity:        0,
				AmountMinted:    0,
				Tradeable:       true,
			},
			{
				ID: "wolf_fur",
				Doubles: []types.DoubleParam{
					{
						Key:          "attack",
						Rate:         sdk.NewDec(1),
						WeightRanges: nil,
						Program:      "0.0",
					},
				},
				Longs: []types.LongParam{
					{
						Key:          "level",
						Rate:         sdk.NewDec(1),
						WeightRanges: nil,
						Program:      "1",
					},
					{
						Key:          "value",
						Rate:         sdk.NewDec(1),
						WeightRanges: nil,
						Program:      "140",
					},
				},
				Strings: []types.StringParam{
					{
						Key:     "Name",
						Rate:    sdk.NewDec(1),
						Value:   "Wolf Fur",
						Program: "",
					},
				},
				MutableStrings:  nil,
				TransferFee:     nil,
				TradePercentage: simInfo.basicTradePercentage,
				Quantity:        0,
				AmountMinted:    0,
				Tradeable:       true,
			},
		},
		ItemModifyOutputs: []types.ItemModifyOutput{
			{
				ID:           "modified_character",
				ItemInputRef: "character",
				Doubles: []types.DoubleParam{
					{
						Key:          "XP",
						Rate:         sdk.OneDec(),
						WeightRanges: nil,
						Program:      "XP + double(15 * 3)",
					},
				},
				Longs: []types.LongParam{
					{
						Key:          "level",
						Rate:         sdk.OneDec(),
						WeightRanges: nil,
						Program:      "level + int(XP / double(level * level * level + 5))",
					},
				},
				Strings:         nil,
				MutableStrings:  nil,
				TransferFee:     nil,
				TradePercentage: simInfo.basicTradePercentage,
				Tradeable:       true,
			},
			{
				ID:              "sword",
				ItemInputRef:    "sword",
				Doubles:         nil,
				Longs:           nil,
				Strings:         nil,
				MutableStrings:  nil,
				TransferFee:     nil,
				TradePercentage: simInfo.basicTradePercentage,
				Tradeable:       true,
			},
		},
	})
	require.NoError(t, err)

	outputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{},
			Weight:   3,
		},
		{
			EntryIDs: []string{"coin_reward", "modified_character"},
			Weight:   3,
		},
		{
			EntryIDs: []string{"coin_reward", "modified_character", "sword"},
			Weight:   24,
		},
		{
			EntryIDs: []string{"coin_reward", "modified_character", "sword", "wolf_tail"},
			Weight:   40,
		},
		{
			EntryIDs: []string{"coin_reward", "modified_character", "sword", "wolf_fur"},
			Weight:   30,
		},
	})

	// Get Character Recipe
	fightWolfWithSwordRecipeID := "LOUDFightWolfWithSword123125"
	fightWolfWithSwordRecipe := []string{
		"LOUD-Fight-Wolf-With-Sword-Recipe",
		"creates a fight instance with a wolf requiring a character and a sword",
		"v0.0.1",
		"[]",
		string(itemInputs),
		string(entries),
		string(outputs),
		"0",
		"true",
		"extraInfo",
	}

	// create recipe
	args := []string{cookbookID, fightWolfWithSwordRecipeID}
	args = append(args, fightWolfWithSwordRecipe...)
	args = append(args, simInfo.common...)
	_, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// Farm this wolf fight
	for i := 0; i < 30; i++ {
		// get sword and character IDs
		itemInputIDs, err := json.Marshal([]string{simInfo.characterID, simInfo.swordID})
		require.NoError(t, err)

		// execute recipe for character
		args = []string{cookbookID, fightWolfWithSwordRecipeID, "0", string(itemInputIDs), "[]"} // empty list for item-ids since there is no item input
		args = append(args, simInfo.common...)
		out, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdExecuteRecipe(), args)
		require.NoError(t, err)
		var resp sdk.TxResponse
		require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
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
		require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &execResp))
		// verify completed
		require.Equal(t, true, execResp.Completed)

		// some items could have been minted from this execution
		// increase itemCount accordingly
		simInfo.itemCount += len(execResp.Execution.ItemOutputIDs)

		// if the character died or their sword was broken, get a new one!
		var itemResp types.QueryGetItemResponse
		args = []string{cookbookID, simInfo.characterID}
		out, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdShowItem(), args)
		require.NoError(t, err)
		require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
		if itemResp.Item.Owner != simInfo.net.Validators[0].Address.String() {
			// PLAYER DIED
			createCharacter(t, simInfo)
			buyCopperSword(t, simInfo)
			continue
		}

		args = []string{cookbookID, simInfo.swordID}
		out, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdShowItem(), args)
		require.NoError(t, err)
		require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
		if itemResp.Item.Owner != simInfo.net.Validators[0].Address.String() {
			// LOST SWORD
			buyCopperSword(t, simInfo)
			continue
		}
	}
}

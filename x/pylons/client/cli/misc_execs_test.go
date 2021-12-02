package cli_test

import (
	"encoding/json"
	"fmt"
	"strconv"
	"testing"
	"time"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"

	"github.com/stretchr/testify/require"
)

func TestSingleItemModifyOutput(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	var err error
	execCount := 0
	itemCount := 0

	basicTradePercentage, err := sdk.NewDecFromStr("0.10")
	require.NoError(t, err)

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	cookbookID := "COOKBOOK_ID"
	cbFields := []string{
		"TestSingleItemModifyOutput",
		"TestSingleItemModifyOutput Cookbook",
		"Pylons Inc",
		"v0.0.1",
		"alex@test.xyz",
		"true",
	}

	// create cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

	// create recipe to mint initial sword item

	require.NoError(t, err)

	damageAmt, err := sdk.NewDecFromStr("8")
	require.NoError(t, err)
	accuracyAmt, err := sdk.NewDecFromStr("0.10")
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{{
			ID: "sword",
			Doubles: []types.DoubleParam{
				{
					Key: "damage",
					WeightRanges: []types.DoubleWeightRange{
						{
							Lower:  damageAmt,
							Upper:  damageAmt,
							Weight: 1,
						},
					},
					Program: "",
				},
				{
					Key: "accuracy",
					WeightRanges: []types.DoubleWeightRange{
						{
							Lower:  accuracyAmt,
							Upper:  accuracyAmt,
							Weight: 1,
						},
					},
					Program: "",
				},
			},
			Strings: []types.StringParam{
				{
					Key:     "DamageType",
					Value:   "slice",
					Program: "",
				},
				{
					Key:     "ItemType",
					Value:   "weapon",
					Program: "",
				},
				{
					Key:     "Description",
					Value:   "Aswordtoslice",
					Program: "",
				},
				{
					Key:     "NFT_URL",
					Value:   "",
					Program: "",
				},
				{
					Key:     "Enchantment",
					Value:   "none",
					Program: "",
				},
			},
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
			EntryIDs: []string{"sword"},
			Weight:   1,
		},
	})
	require.NoError(t, err)

	mintItemRecipeID := "MINT_ITEM_RECIPE_ID"
	mintNFTRecipe := []string{
		"Mint Sword Item Recipe",
		"Mint Sword Item Recipe",
		"v0.0.1",
		"10node0token",
		"[]",
		string(entries),
		string(itemOutputs),
		"0",
		"12upylon",
		"true",
		"extraInfo",
	}

	// create recipe
	args = []string{cookbookID, mintItemRecipeID}
	args = append(args, mintNFTRecipe...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	// Execute recipe and check item
	// execute recipe to mint
	args = []string{cookbookID, mintItemRecipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
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
	swordID := types.EncodeItemID(uint64(itemCount))
	itemCount++
	args = []string{cookbookID, swordID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)
	fmt.Println(itemResp.Item)

	// create recipe to modify the sword

	coinInputs := "100node0token"
	require.NoError(t, err)

	itemInputs, err := json.Marshal([]types.ItemInput{
		{
			ID: "weapon",
			Strings: []types.StringInputParam{
				{
					Key:   "ItemType",
					Value: "weapon",
				},
			},
		},
	})
	require.NoError(t, err)

	entries, err = json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: nil,
		ItemModifyOutputs: []types.ItemModifyOutput{
			{
				ID:           "enchantedWeapon",
				ItemInputRef: "weapon",
				Strings: []types.StringParam{
					{
						Key:   "Enchantment",
						Value: "blingbling",
					},
				},
				MutableStrings:  nil,
				TransferFee:     nil,
				TradePercentage: basicTradePercentage,
				Tradeable:       true,
			},
		},
	})
	require.NoError(t, err)

	outputs, err := json.Marshal([]types.WeightedOutputs{
		{
			EntryIDs: []string{"enchantedWeapon"},
			Weight:   1,
		},
	})
	require.NoError(t, err)

	modifyItemRecipeID := "MODIFY_ITEM_RECIPE_ID"
	modifyNFTRecipe := []string{
		"Modify Sword Item Recipe",
		"Modify Sword Item Recipe",
		"v0.0.1",
		coinInputs,
		string(itemInputs),
		string(entries),
		string(outputs),
		"0",
		"12upylon",
		"true",
		"extraInfo",
	}

	// create recipe
	args = []string{cookbookID, modifyItemRecipeID}
	args = append(args, modifyNFTRecipe...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)

	itemInputIDs, err := json.Marshal([]string{swordID})
	require.NoError(t, err)

	// Execute recipe and check item
	// execute recipe to mint
	args = []string{cookbookID, modifyItemRecipeID, "0", string(itemInputIDs), "[]"} // empty list for item-ids since there is no item input
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdExecuteRecipe(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
	require.Equal(t, uint32(0), resp.Code)

	// simulate waiting for later block heights
	height, err = net.LatestHeight()
	targetHeight = height + 1
	// build execID from the execution height
	execID = strconv.Itoa(int(height+0)) + "-" + strconv.Itoa(execCount)
	execCount++
	require.NoError(t, err)
	_, err = net.WaitForHeightWithTimeout(targetHeight, 60*time.Second)
	require.NoError(t, err)

	// check the execution
	args = []string{execID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowExecution(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &execResp))
	// verify completed
	require.Equal(t, true, execResp.Completed)

	// check the item, itemID is i
	args = []string{cookbookID, swordID}
	out, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookID, itemResp.Item.CookbookID)

	fmt.Println(itemResp.Item)
}

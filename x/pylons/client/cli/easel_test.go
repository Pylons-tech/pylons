package cli_test

import (
	"encoding/json"
	"fmt"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"strconv"
	"testing"
	"time"
)

const (
	cookbookIDEasel = "cookbookEasel"
)

type easelBasicSim struct {
	net                    *network.Network
	ctx                    client.Context
	basicTradePercentage   sdk.Dec
	err                    error
	common                 []string
	execCount              int
	itemCount              int
	mintRecipeID string
}

func TestEaselBasic(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	var err error

	simInfo := &easelBasicSim{
		net:                  net,
		ctx:                  ctx,
		basicTradePercentage: sdk.Dec{},
		err:                  nil,
		common:               nil,
	}

	simInfo.basicTradePercentage, err = sdk.NewDecFromStr("0.10")
	require.NoError(t, err)

	simInfo.common = []string{

		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	createEaselCookbook(t, simInfo)
	createMintRecipe(t, simInfo)
	mintNFT(t, simInfo)
}

func createEaselCookbook(t *testing.T, simInfo *easelBasicSim) {

	cbFields := []string{
		"Easel Test Cookbook",
		"Cookbook for testing demo easel transactions",
		"Pylons Inc",
		"v0.0.1",
		"alex@shmeeload.xyz",
		"{\"denom\": \"pylons\", \"amount\": \"12\"}",
		"true",
	}

	// create LOUD cookbook
	args := []string{cookbookIDEasel}
	args = append(args, cbFields...)
	args = append(args, simInfo.common...)
	_, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
}

func createMintRecipe(t *testing.T, simInfo *easelBasicSim) {
	coinInputs, err := json.Marshal([]types.CoinInput{
		{Coins: sdk.NewCoins(sdk.NewCoin("node0token", sdk.NewInt(10)))},
	})
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{{
			ID: "title_title",
			Strings: []types.StringParam{
				{
					Key:     "NFT_URL",
					Value:   "https://www.imagesource.com/wp-content/uploads/2019/06/Rio.jpg",
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
		 	EntryIDs: []string{"title_title"},
			Weight:   1,
		},
	})

	// Get Character Recipe
	simInfo.mintRecipeID = "EaselMintNFT23418234129"
	mintNFTRecipe := []string{
		"Easel-Mint-NFT-Recipe",
		"A recipe with a URL for a minted image NFT",
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
	args := []string{cookbookIDEasel, simInfo.mintRecipeID}
	args = append(args, mintNFTRecipe...)
	fmt.Println(args)
	args = append(args, simInfo.common...)
	_, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
}


func mintNFT(t *testing.T, simInfo *easelBasicSim) {
	// execute recipe to mint
	args := []string{cookbookIDEasel, simInfo.mintRecipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
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
	nftID := types.EncodeItemID(uint64(simInfo.itemCount))
	simInfo.itemCount++
	args = []string{cookbookIDEasel, nftID}
	out, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookIDEasel, itemResp.Item.CookbookID)
}
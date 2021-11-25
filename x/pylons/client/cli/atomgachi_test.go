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

const (
	cookbookIDAtomgachi = "atomgachiV2"
)

type atomgachiBasicSim struct {
	net                  *network.Network
	ctx                  client.Context
	basicTradePercentage sdk.Dec
	err                  error
	common               []string
	execCount            int
	itemCount            int
	mintRecipeID         string
	mintRecipeID2        string
}

func TestAtomgachiBasic(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	var err error

	simInfo := &atomgachiBasicSim{
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

	createAtomgachiCookbook(t, simInfo)
	createMintRecipe(t, simInfo)
	mint(t, simInfo)
}

func createAtomgachiCookbook(t *testing.T, simInfo *atomgachiBasicSim) {
	cbFields := []string{
		"Atomgachi Test Cookbook",
		"Cookbook for testing demo atomgachi transactions",
		"Pylons Inc",
		"v0.0.1",
		"alex@shmeeload.xyz",
		"true",
	}

	// create Atomgachi cookbook
	args := []string{cookbookIDAtomgachi}
	args = append(args, cbFields...)
	args = append(args, simInfo.common...)
	_, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
}

func createMintRecipe(t *testing.T, simInfo *atomgachiBasicSim) {
	coinInputs, err := json.Marshal([]types.CoinInput{})
	require.NoError(t, err)

	entries, err := json.Marshal(types.EntriesList{
		CoinOutputs: nil,
		ItemOutputs: []types.ItemOutput{{
			ID: "atomgachiTestCreate",
			Strings: []types.StringParam{
				{
					Key:     "name",
					Value:   "testObject",
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
			EntryIDs: []string{"atomgachiTestCreate"},
			Weight:   1,
		},
	})

	// Get Character Recipe
	simInfo.mintRecipeID = "atomgachiTestCreate"
	mintNFTRecipe := []string{
		"Atom with it's Number here",
		"mijollae is testing the demo process",
		"v0.0.1",
		string(coinInputs),
		"[]",
		string(entries),
		string(itemOutputs),
		"0",
		"{\"denom\": \"upylon\", \"amount\": \"12\"}",
		"true",
		"extraInfo",
	}

	// create recipe
	args := []string{cookbookIDAtomgachi, simInfo.mintRecipeID}
	args = append(args, mintNFTRecipe...)
	fmt.Println(args)
	args = append(args, simInfo.common...)
	_, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
}

func mint(t *testing.T, simInfo *atomgachiBasicSim) {
	// execute recipe to mint
	args := []string{cookbookIDAtomgachi, simInfo.mintRecipeID, "0", "[]", "[]"} // empty list for item-ids since there is no item input
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
	args = []string{cookbookIDAtomgachi, nftID}
	out, err = clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdShowItem(), args)
	require.NoError(t, err)
	var itemResp types.QueryGetItemResponse
	require.NoError(t, simInfo.ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &itemResp))
	require.Equal(t, cookbookIDAtomgachi, itemResp.Item.CookbookID)
}

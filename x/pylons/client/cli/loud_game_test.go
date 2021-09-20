package cli_test

import (
	"encoding/json"
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

func TestLOUDBasic(t *testing.T) {
	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cookbookID := "cookbookLOUD"

	basicTradePercentage, err := sdk.NewDecFromStr("0.10")
	require.NoError(t, err)

	cbFields := []string{
		"Legend of the Undead Dragon",
		"Cookbook for running pylons recreation of LOUD",
		"Pylons Inc",
		"v0.0.1",
		"alex@shmeeload.xyz",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	common := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, val.Address.String()),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
	}

	// create LOUD cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)

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
	args = []string{cookbookID, getCharacterRecipeID}
	args = append(args, getCharacterRecipe...)
	args = append(args, common...)
	_, err = clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateRecipe(), args)
	require.NoError(t, err)
}

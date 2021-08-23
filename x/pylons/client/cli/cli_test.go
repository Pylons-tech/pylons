package cli_test

import (
	"strconv"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/Pylons-tech/pylons/testutil/network"
)

func networkWithCookbookObjects(t *testing.T, n int) (*network.Network, []types.Cookbook) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.CookbookList = append(state.CookbookList, types.Cookbook{
			Creator:      "ANY",
			ID:           strconv.Itoa(i),
			CostPerBlock: sdk.NewCoin("test", sdk.NewInt(1)),
		})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.CookbookList
}

func networkWithExecutionObjects(t *testing.T, n int) (*network.Network, []types.Execution) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.ExecutionList = append(state.ExecutionList,
			types.Execution{
				Creator:             "ANY",
				ID:                  strconv.Itoa(i),
				NodeVersion:         "v1.0.0",
				CoinOutputs:         sdk.Coins{},
				ItemInputs:          make([]types.ItemRecord, 0),
				ItemOutputIDs:       make([]string, 0),
				ItemModifyOutputIDs: make([]string, 0),
				Recipe: types.Recipe{
					CookbookID:  "",
					ID:          "",
					NodeVersion: "",
					Name:        "",
					Description: "",
					Version:     "",
					CoinInputs:  sdk.Coins{},
					ItemInputs:  make([]types.ItemInput, 0),
					Entries: types.EntriesList{
						CoinOutputs:       make([]types.CoinOutput, 0),
						ItemOutputs:       make([]types.ItemOutput, 0),
						ItemModifyOutputs: make([]types.ItemModifyOutput, 0),
					},
					Outputs:       make([]types.WeightedOutputs, 0),
					BlockInterval: 0,
					Enabled:       false,
					ExtraInfo:     "",
				},
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.ExecutionList
}

func networkWithGoogleIAPOrderObjects(t *testing.T, n int) (*network.Network, []types.GoogleInAppPurchaseOrder) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.GoogleInAppPurchaseOrderList = append(state.GoogleInAppPurchaseOrderList, types.GoogleInAppPurchaseOrder{Creator: "ANY", PurchaseToken: strconv.Itoa(i)})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.GoogleInAppPurchaseOrderList
}

func networkWithItemObjects(t *testing.T, n int) (*network.Network, []types.Item) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.ItemList = append(state.ItemList,
			types.Item{
				Owner:          "ANY",
				ID:             strconv.Itoa(i),
				CookbookID:     "testCookbookID",
				NodeVersion:    "0.0.1",
				Doubles:        make([]types.DoubleKeyValue, 0),
				Longs:          make([]types.LongKeyValue, 0),
				Strings:        make([]types.StringKeyValue, 0),
				MutableStrings: make([]types.StringKeyValue, 0),
				Tradeable:      false,
				LastUpdate:     0,
				TransferFee:    sdk.Coin{Denom: "test", Amount: sdk.NewInt(1)},
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.ItemList
}

func networkWithRecipeObjects(t *testing.T, n int) (*network.Network, []types.Recipe, []types.Cookbook) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.RecipeList = append(
			state.RecipeList,
			types.Recipe{
				CookbookID:    strconv.Itoa(i),
				ID:            strconv.Itoa(i),
				NodeVersion:   "",
				Name:          "",
				Description:   "",
				Version:       "",
				CoinInputs:    sdk.Coins{},
				ItemInputs:    make([]types.ItemInput, 0),
				Entries:       types.EntriesList{CoinOutputs: []types.CoinOutput{}, ItemOutputs: []types.ItemOutput{}, ItemModifyOutputs: []types.ItemModifyOutput{}},
				Outputs:       make([]types.WeightedOutputs, 0),
				BlockInterval: 0x0,
				Enabled:       false,
				ExtraInfo:     "",
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.RecipeList, nil
}

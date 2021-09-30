package cli_test

import (
	"strconv"
	"testing"

	"github.com/cosmos/cosmos-sdk/crypto/hd"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/Pylons-tech/pylons/testutil/network"
)

func generateAddressesInKeyring(ring keyring.Keyring, n int) []sdk.AccAddress {
	addrs := make([]sdk.AccAddress, n)
	for i := 0; i < n; i++ {
		info, _, _ := ring.NewMnemonic("NewUser"+strconv.Itoa(i), keyring.English, sdk.FullFundraiserPath, keyring.DefaultBIP39Passphrase, hd.Secp256k1)
		addrs[i] = info.GetAddress()
	}
	return addrs
}

func networkWithAccountObjects(t *testing.T, n int) (*network.Network, []types.UserMap) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	creators := types.GenTestBech32List(n)

	for i := 0; i < n; i++ {
		state.AccountList = append(state.AccountList,
			types.UserMap{
				AccountAddr: creators[i],
				Username:    "user" + strconv.Itoa(i),
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.AccountList
}

func networkWithTradeObjects(t *testing.T, n int) (*network.Network, []types.Trade) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)

	for i := 0; i < n; i++ {
		state.TradeList = append(state.TradeList, types.Trade{
			Creator:          addresses[i],
			ID:               uint64(i),
			CoinInputs:       []types.CoinInput{{Coins: sdk.NewCoins()}},
			ItemInputs:       make([]types.ItemInput, 0),
			CoinOutputs:      sdk.NewCoins(),
			ItemOutputs:      make([]types.ItemRef, 0),
			ExtraInfo:        "extra info",
			Receiver:         "receiver",
			TradedItemInputs: make([]types.ItemRef, 0),
		})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.TradeList
}

// A network with cookbook object just contains a state of:
//	 	N cookbooks
func networkWithCookbookObjects(t *testing.T, n int) (*network.Network, []types.Cookbook) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)

	for i := 0; i < n; i++ {
		state.CookbookList = append(state.CookbookList, types.Cookbook{
			Creator:      addresses[i],
			ID:           strconv.Itoa(i),
			NodeVersion:  "v1.0.0",
			Name:         "testCookbookName" + strconv.Itoa(i),
			Description:  "testCookbookDescription" + strconv.Itoa(i),
			Developer:    "testDeveloper" + strconv.Itoa(i),
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			CostPerBlock: sdk.Coin{
				Denom:  "testDenom" + strconv.Itoa(i),
				Amount: sdk.OneInt(),
			},
			Enabled: false,
		})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.CookbookList
}

// A network with execution objects  contains a state of:
//	 	N cookbooks
//		N recipes (1 per cookbook)
// 		N executions (1 per recipe)
func networkWithExecutionObjects(t *testing.T, n int) (*network.Network, []types.Execution) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)

	for i := 0; i < n; i++ {
		state.ExecutionList = append(state.ExecutionList,
			types.Execution{
				Creator:     addresses[i],
				ID:          strconv.Itoa(i),
				NodeVersion: "v1.0.0",
				CoinOutputs: sdk.NewCoins(sdk.NewCoin(
					"testDenom"+strconv.Itoa(i),
					sdk.OneInt(),
				)),
				ItemInputs:          make([]types.ItemRecord, 0),
				ItemOutputIDs:       []string{"itemID1"},
				ItemModifyOutputIDs: make([]string, 0),
				RecipeID:            "RecipeID1",
				CookbookID:          "CookbookID1",
				CoinInputs:          sdk.NewCoins(),
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

	addresses := types.GenTestBech32List(n)

	for i := 0; i < n; i++ {
		state.ItemList = append(state.ItemList,
			types.Item{
				Owner:           addresses[i],
				ID:              strconv.Itoa(i),
				CookbookID:      "testCookbookID",
				NodeVersion:     "0.0.1",
				Doubles:         make([]types.DoubleKeyValue, 0),
				Longs:           make([]types.LongKeyValue, 0),
				Strings:         make([]types.StringKeyValue, 0),
				MutableStrings:  make([]types.StringKeyValue, 0),
				Tradeable:       false,
				LastUpdate:      0,
				TradePercentage: sdk.NewDec(0),
				TransferFee:     []sdk.Coin{{Denom: "test", Amount: sdk.OneInt()}},
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.ItemList
}

func networkWithItemObjectsSingleOwner(t *testing.T, n int) (*network.Network, []types.Item) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(1)

	for i := 0; i < n; i++ {
		state.ItemList = append(state.ItemList,
			types.Item{
				Owner:           addresses[0],
				ID:              strconv.Itoa(i),
				CookbookID:      "testCookbookID",
				NodeVersion:     "0.0.1",
				Doubles:         make([]types.DoubleKeyValue, 0),
				Longs:           make([]types.LongKeyValue, 0),
				Strings:         make([]types.StringKeyValue, 0),
				MutableStrings:  make([]types.StringKeyValue, 0),
				Tradeable:       false,
				LastUpdate:      0,
				TradePercentage: sdk.NewDec(0),
				TransferFee:     []sdk.Coin{{Denom: "test", Amount: sdk.OneInt()}},
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
				CoinInputs:    []types.CoinInput{{Coins: sdk.NewCoins()}},
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

package cli

import (
	"fmt"
	"strconv"
	"testing"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/crypto/hd"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"

	sdk "github.com/cosmos/cosmos-sdk/types"
	bank "github.com/cosmos/cosmos-sdk/x/bank/client/cli"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/Pylons-tech/pylons/testutil/network"
)

const (
	TestIBCDenom = "ibc/529ba5e3e86ba7796d7caab4fc02728935fbc75c0f7b25a9e611c49dd7d68a35"
)

var newCoin = sdk.NewInt(10)

func CommonArgs(address string, net *network.Network) []string {
	return []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, address),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, newCoin)).String()),
	}
}

func GenerateAddressesInKeyring(ring keyring.Keyring, n int) []sdk.AccAddress {
	addrs := make([]sdk.AccAddress, n)
	for i := 0; i < n; i++ {
		var err error
		info, _, _ := ring.NewMnemonic("NewUser"+strconv.Itoa(i), keyring.English, sdk.FullFundraiserPath, keyring.DefaultBIP39Passphrase, hd.Secp256k1)
		addrs[i], err = info.GetAddress()
		if err != nil {
			panic(err)
		}
		_, err = info.GetPubKey()
		if err != nil {
			panic(err)
		}
	}
	return addrs
}

func GenerateAddressWithAccount(ctx client.Context, t *testing.T, net *network.Network) (string, error) {
	accs := GenerateAddressesInKeyring(ctx.Keyring, 1)
	common := CommonArgs(accs[0].String(), net)

	username := "user"
	usernameToken := "usernameToken"
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	// create account
	args := []string{username, usernameToken}
	args = append(args, common...)
	out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
	if err != nil {
		return "", err
	}
	var resp sdk.TxResponse
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	if uint32(0) != resp.Code {
		return "", fmt.Errorf("error code not 'Success'")
	}

	common = CommonArgs(net.Validators[0].Address.String(), net)

	args = []string{net.Validators[0].Address.String(), accs[0].String(), "1000node0token"}
	args = append(args, common...)
	out, err = clitestutil.ExecTestCLICmd(ctx, bank.NewSendTxCmd(), args)
	if err != nil {
		return "", err
	}
	require.NoError(t, ctx.Codec.UnmarshalJSON(out.Bytes(), &resp))
	if uint32(0) != resp.Code {
		return "", fmt.Errorf("error code not 'Success'")
	}
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	return accs[0].String(), nil
}

func NetworkWithRedeemInfoObjects(t *testing.T, n int) (*network.Network, []types.RedeemInfo) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)
	for i := 0; i < n; i++ {
		state.RedeemInfoList = append(state.RedeemInfoList, types.RedeemInfo{Address: addresses[i], Id: strconv.Itoa(i), Amount: sdk.OneInt()})
	}

	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.RedeemInfoList
}

func NetworkWithAccountObjects(t *testing.T, n int) (*network.Network, []types.UserMap) {
	t.Helper()
	cfg := app.DefaultConfig()
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

func NetworkWithTradeObjects(t *testing.T, n int) (*network.Network, []types.Trade) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)

	coinInputs := make([]types.CoinInput, 0)
	coinInputs = append(coinInputs, types.CoinInput{Coins: sdk.Coins{sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)}}})

	for i := 0; i < n; i++ {
		state.TradeList = append(state.TradeList, types.Trade{
			Creator:          addresses[i],
			Id:               uint64(i),
			CoinInputs:       coinInputs,
			ItemInputs:       make([]types.ItemInput, 0),
			CoinOutputs:      sdk.Coins{sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)}},
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

func NetworkWithTradeObjectsSingleOwner(t *testing.T, n int) (*network.Network, []types.Trade) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(1)

	for i := 0; i < n; i++ {
		state.TradeList = append(state.TradeList, types.Trade{
			Creator:          addresses[0],
			Id:               uint64(i),
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
func NetworkWithCookbookObjects(t *testing.T, n int) (*network.Network, []types.Cookbook) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)

	for i := 0; i < n; i++ {
		state.CookbookList = append(state.CookbookList, types.Cookbook{
			Creator:      addresses[i],
			Id:           strconv.Itoa(i),
			NodeVersion:  0,
			Name:         "testCookbookName" + strconv.Itoa(i),
			Description:  "testCookbookDescription" + strconv.Itoa(i),
			Developer:    "testDeveloper" + strconv.Itoa(i),
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			Enabled:      false,
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
func NetworkWithExecutionObjects(t *testing.T, n int) (*network.Network, []types.Execution) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)

	for i := 0; i < n; i++ {
		state.ExecutionList = append(state.ExecutionList,
			types.Execution{
				Creator:     addresses[i],
				Id:          strconv.Itoa(i),
				NodeVersion: 0,
				CoinOutputs: sdk.NewCoins(sdk.NewCoin(
					"testDenom"+strconv.Itoa(i),
					sdk.OneInt(),
				)),
				ItemInputs:          make([]types.ItemRecord, 0),
				ItemOutputIds:       []string{"itemID1"},
				ItemModifyOutputIds: make([]string, 0),
				RecipeId:            "RecipeID1",
				CookbookId:          "CookbookID1",
				CoinInputs:          sdk.NewCoins(),
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.ExecutionList
}

func NetworkWithGoogleIAPOrderObjects(t *testing.T, n int) (*network.Network, []types.GoogleInAppPurchaseOrder) {
	t.Helper()
	cfg := app.DefaultConfig()
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

func NetworkWithPaymentInfoObjects(t *testing.T, n int) (*network.Network, []types.PaymentInfo) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)
	for i := 0; i < n; i++ {
		state.PaymentInfoList = append(state.PaymentInfoList, types.PaymentInfo{PayerAddr: addresses[i], PurchaseId: strconv.Itoa(i), Amount: sdk.OneInt()})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.PaymentInfoList
}

func NetworkWithItemObjects(t *testing.T, n int) (*network.Network, []types.Item) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(n)

	for i := 0; i < n; i++ {
		state.ItemList = append(state.ItemList,
			types.Item{
				Owner:           addresses[i],
				Id:              strconv.Itoa(i),
				CookbookId:      "testCookbookID",
				NodeVersion:     0,
				Doubles:         make([]types.DoubleKeyValue, 0),
				Longs:           make([]types.LongKeyValue, 0),
				Strings:         make([]types.StringKeyValue, 0),
				MutableStrings:  make([]types.StringKeyValue, 0),
				Tradeable:       false,
				LastUpdate:      0,
				TradePercentage: sdk.ZeroDec(),
				TransferFee:     []sdk.Coin{{Denom: "test", Amount: sdk.OneInt()}},
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.ItemList
}

func NetworkWithItemObjectsSingleOwner(t *testing.T, n int) (*network.Network, []types.Item) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	addresses := types.GenTestBech32List(1)

	for i := 0; i < n; i++ {
		state.ItemList = append(state.ItemList,
			types.Item{
				Owner:           addresses[0],
				Id:              strconv.Itoa(i),
				CookbookId:      "testCookbookID",
				NodeVersion:     0,
				Doubles:         make([]types.DoubleKeyValue, 0),
				Longs:           make([]types.LongKeyValue, 0),
				Strings:         make([]types.StringKeyValue, 0),
				MutableStrings:  make([]types.StringKeyValue, 0),
				Tradeable:       false,
				LastUpdate:      0,
				TradePercentage: sdk.ZeroDec(),
				TransferFee:     []sdk.Coin{{Denom: "test", Amount: sdk.OneInt()}},
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.ItemList
}

func NetworkWithRecipeObjects(t *testing.T, n int) (*network.Network, []types.Recipe, []types.Cookbook) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.RecipeList = append(
			state.RecipeList,
			types.Recipe{
				CookbookId:    strconv.Itoa(i),
				Id:            strconv.Itoa(i),
				NodeVersion:   0,
				Name:          "",
				Description:   "",
				Version:       "",
				CoinInputs:    []types.CoinInput{{Coins: sdk.NewCoins()}},
				ItemInputs:    make([]types.ItemInput, 0),
				Entries:       types.EntriesList{CoinOutputs: []types.CoinOutput{}, ItemOutputs: []types.ItemOutput{}, ItemModifyOutputs: []types.ItemModifyOutput{}},
				Outputs:       make([]types.WeightedOutputs, 0),
				BlockInterval: 0x0,
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				Enabled:       false,
				ExtraInfo:     "",
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.RecipeList, nil
}

func NetworkWithRecipeObjectsHistory(t *testing.T, n int) (*network.Network, []types.Recipe, []types.Cookbook) {
	t.Helper()
	cfg := app.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.RecipeList = append(
			state.RecipeList,
			types.Recipe{
				CookbookId:    "testCookbook",
				Id:            "testRecipe",
				NodeVersion:   0,
				Name:          "",
				Description:   "",
				Version:       "",
				CoinInputs:    []types.CoinInput{{Coins: sdk.NewCoins()}},
				ItemInputs:    make([]types.ItemInput, 0),
				Entries:       types.EntriesList{CoinOutputs: []types.CoinOutput{}, ItemOutputs: []types.ItemOutput{}, ItemModifyOutputs: []types.ItemModifyOutput{}},
				Outputs:       make([]types.WeightedOutputs, 0),
				BlockInterval: 0x0,
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
				Enabled:       true,
				ExtraInfo:     "",
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.RecipeList, nil
}

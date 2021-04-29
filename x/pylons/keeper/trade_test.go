package keeper

import (
	"reflect"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func GenTrade(sender sdk.AccAddress, itemList types.ItemList, pylonsAmount int64) types.Trade {
	return types.NewTrade("extra info",
		types.GenCoinInputList("wood", 5),
		types.GenTradeItemInputList("LOUD-CB-001", []string{"Raichu"}),
		types.NewPylon(pylonsAmount),
		itemList,
		sender,
	)
}

func TestGetTrade(t *testing.T) {
	tci := SetupTestCoinInput()
	sender, _, _, _ := SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")
	item := GenItem(cbData.ID, sender, "Raichu")
	err := tci.PlnK.SetItem(tci.Ctx, item)

	require.NoError(t, err)

	cases := map[string]struct {
		sender       sdk.AccAddress
		itemList     types.ItemList
		pylonsAmount int64
		showError    bool
	}{
		"basic flow test": {
			sender,
			types.ItemList{
				item,
			},
			0,
			false,
		},
		"error for empty sender": {
			nil,
			types.ItemList{
				item,
			},
			0,
			true,
		},
	}

	for name, test := range cases {
		t.Run(name, func(t *testing.T) {
			trade := GenTrade(test.sender, test.itemList, test.pylonsAmount)
			err := tci.PlnK.SetTrade(tci.Ctx, trade)

			if test.showError {
				require.True(t, err != nil)
			} else {
				require.NoError(t, err)
				storedTrade, err := tci.PlnK.GetTrade(tci.Ctx, trade.ID)
				require.NoError(t, err)
				require.True(t, reflect.DeepEqual(trade.CoinOutputs, storedTrade.CoinOutputs))
				require.True(t, reflect.DeepEqual(trade.CoinInputs, storedTrade.CoinInputs))
				require.True(t, reflect.DeepEqual(trade.ItemInputs, storedTrade.ItemInputs))
				require.True(t, reflect.DeepEqual(trade.ItemOutputs, storedTrade.ItemOutputs))
				require.True(t, reflect.DeepEqual(trade.Sender, storedTrade.Sender))
			}
		})

	}

}

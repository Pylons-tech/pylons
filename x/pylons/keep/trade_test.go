package keep

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
		types.GenItemInputList("Raichu"),
		types.NewPylon(pylonsAmount),
		itemList,
		sender,
	)
}

func TestGetTrade(t *testing.T) {
	mockedCoinInput := SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	cbData := GenCookbook(sender, "cookbook-0001", "this has to meet character limits")

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.NewPylon(1000000))

	item := GenItem(cbData.ID, sender, "Raichu")
	err := mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)

	require.True(t, err == nil)

	cases := map[string]struct {
		sender       sdk.AccAddress
		itemList     types.ItemList
		pylonsAmount int64
		showError    bool
	}{
		"basic flow test": {
			sender,
			types.ItemList{
				*item,
			},
			0,
			false,
		},
		"error for empty sender": {
			nil,
			types.ItemList{
				*item,
			},
			0,
			true,
		},
	}

	for name, test := range cases {
		t.Run(name, func(t *testing.T) {
			trade := GenTrade(test.sender, test.itemList, test.pylonsAmount)
			err := mockedCoinInput.PlnK.SetTrade(mockedCoinInput.Ctx, trade)

			if test.showError {
				require.True(t, err != nil)
			} else {
				require.True(t, err == nil)
				storedTrade, err := mockedCoinInput.PlnK.GetTrade(mockedCoinInput.Ctx, trade.ID)
				require.True(t, err == nil)
				require.True(t, reflect.DeepEqual(trade.CoinOutputs, storedTrade.CoinOutputs))
				require.True(t, reflect.DeepEqual(trade.CoinInputs, storedTrade.CoinInputs))
				require.True(t, reflect.DeepEqual(trade.ItemInputs, storedTrade.ItemInputs))
				require.True(t, reflect.DeepEqual(trade.ItemOutputs, storedTrade.ItemOutputs))
				require.True(t, reflect.DeepEqual(trade.Sender, storedTrade.Sender))

			}
		})

	}

}

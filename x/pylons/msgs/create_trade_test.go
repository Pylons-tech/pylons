package msgs

import (
	"bytes"
	"encoding/json"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCreateTradeGetSignBytesItemInput(t *testing.T) {
	sdkAddr, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	require.True(t, err == nil)
	msg := NewMsgCreateTrade(
		nil,
		types.GenTradeItemInputList("UTestCreateTrade-CB-001", []string{"Raichu"}),
		types.NewPylon(10),
		nil,
		"Test CreateTrade GetSignBytes",
		sdkAddr)
	err = msg.ValidateBasic()
	require.True(t, err == nil)

	expectedSignBytes := `{
			"CoinInputs":null,
			"CoinOutputs":[{"amount":"10","denom":"pylon"}],
			"ExtraInfo":"Test CreateTrade GetSignBytes",
			"ItemInputs":[
				{
					"CookbookID":"UTestCreateTrade-CB-001",
					"ItemInput":{
						"AdditionalItemSendFee":{"MinValue":0,"MaxValue":10000},
						"Doubles":null,
						"Longs":null,
						"Strings":[{
							"Key":"Name",
							"Value":"Raichu"
						}]
					}
				}
			],
			"ItemOutputs":null,
			"Sender":"cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
		}`
	buffer := new(bytes.Buffer)
	err = json.Compact(buffer, []byte(expectedSignBytes))
	require.True(t, err == nil)
	require.True(t, string(msg.GetSignBytes()) == buffer.String())
}

func TestCreateTradeGetSignBytesUnorderedCoinInputs(t *testing.T) {
	sdkAddr, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	require.True(t, err == nil)
	msg := NewMsgCreateTrade(
		types.CoinInputList{
			types.CoinInput{Coin: "aaaa", Count: 100},
			types.CoinInput{Coin: "zzzz", Count: 100},
			types.CoinInput{Coin: "cccc", Count: 100},
		},
		nil,
		types.NewPylon(10),
		nil,
		"Test CreateTrade GetSignBytes",
		sdkAddr)
	err = msg.ValidateBasic()
	require.True(t, err == nil)

	expectedSignBytes := `{
		"CoinInputs": [
			{
				"Coin": "aaaa",
				"Count": "100"
			},
			{
				"Coin": "zzzz",
				"Count": "100"
			},
			{
				"Coin": "cccc",
				"Count": "100"
			}
		],
		"CoinOutputs": [
			{
				"amount": "10",
				"denom": "pylon"
			}
		],
		"ExtraInfo": "Test CreateTrade GetSignBytes",
		"ItemInputs": null,
		"ItemOutputs": null,
		"Sender": "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	}`
	buffer := new(bytes.Buffer)
	err = json.Compact(buffer, []byte(expectedSignBytes))
	require.True(t, err == nil)
	require.True(t, string(msg.GetSignBytes()) == buffer.String())
}

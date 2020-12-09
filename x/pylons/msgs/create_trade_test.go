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
	require.NoError(t, err)
	msg := NewMsgCreateTrade(
		nil,
		types.GenTradeItemInputList("UTestCreateTrade-CB-001", []string{"Raichu"}),
		types.NewPylon(10),
		nil,
		"Test CreateTrade GetSignBytes",
		sdkAddr)
	err = msg.ValidateBasic()
	require.NoError(t, err)

	expectedSignBytes := `{
			"CoinInputs":null,
			"CoinOutputs":[{"amount":"10","denom":"pylon"}],
			"ExtraInfo":"Test CreateTrade GetSignBytes",
			"ItemInputs":[
				{
					"CookbookID":"UTestCreateTrade-CB-001",
					"ItemInput":{
						"Doubles":null,
						"ID":"Raichu",
						"Longs":null,
						"Strings":[{
							"Key":"Name",
							"Value":"Raichu"
						}],
						"TransferFee":{"MaxValue":10000,"MinValue":0}
					}
				}
			],
			"ItemOutputs":null,
			"Sender":"cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
		}`
	buffer := new(bytes.Buffer)
	err = json.Compact(buffer, []byte(expectedSignBytes))
	require.NoError(t, err)
	require.True(t, string(msg.GetSignBytes()) == buffer.String(), string(msg.GetSignBytes()))
}

func TestCreateTradeGetSignBytesUnorderedCoinInputs(t *testing.T) {
	sdkAddr, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	require.NoError(t, err)
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
	require.NoError(t, err)

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
	require.NoError(t, err)
	require.True(t, string(msg.GetSignBytes()) == buffer.String())
}

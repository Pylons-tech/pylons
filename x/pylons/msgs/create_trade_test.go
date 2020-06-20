package msgs

import (
	"bytes"
	"encoding/json"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCreateTradeGetSignBytes(t *testing.T) {
	sdkAddr, err := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	require.True(t, err == nil)
	msg := NewMsgCreateTrade(
		nil,
		types.GenTradeItemInputList("UTestCreateTrade-CB-001", []string{"Raichu"}),
		types.NewPylon(10),
		nil,
		"Test CreateTrade GetSignBytes",
		sdkAddr)
	expectedSignBytes := `{
			"CoinInputs":null,
			"CoinOutputs":[{"amount":"10","denom":"pylon"}],
			"ExtraInfo":"Test CreateTrade GetSignBytes",
			"ItemInputs":[
				{
					"CookbookID":"UTestCreateTrade-CB-001",
					"ItemInput":{
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

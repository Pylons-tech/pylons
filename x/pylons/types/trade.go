package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeTrade is a store key for trade
const TypeTrade = "trade"

// NewTrade creates a new trade
func NewTrade(extraInfo string,
	coinInputs CoinInputList, // coinOutputs CoinOutputList,
	itemInputs TradeItemInputList, // itemOutputs ItemOutputList,
	coinOutputs sdk.Coins, // newly created param instead of coinOutputs and itemOutputs
	itemOutputs ItemList,
	sender sdk.AccAddress) Trade {
	trd := Trade{
		NodeVersion: "0.0.1",
		CoinInputs:  coinInputs,
		ItemInputs:  itemInputs,
		CoinOutputs: coinOutputs,
		ItemOutputs: itemOutputs,
		ExtraInfo:   extraInfo,
		Sender:      sender.String(),
	}

	trd.ID = KeyGen(sender)
	return trd
}

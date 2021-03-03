package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeTrade is a store key for trade
const TypeTrade = "trade"

// Trade is a construct to perform exchange of items and coins between users. Initiated by the sender and completed by
// the FulFiller.
type Trade struct {
	NodeVersion SemVer
	ID          string             // the trade guid
	CoinInputs  CoinInputList      // coins that the fulfiller should send to creator
	ItemInputs  TradeItemInputList // items that the fulfiller should send to creator
	CoinOutputs sdk.Coins          // coins that the creator should send to fulfiller
	ItemOutputs ItemList           // items that the creator should send to fulfiller
	ExtraInfo   string             // custom trade info text
	Sender      sdk.AccAddress     // trade creator address
	FulFiller   sdk.AccAddress     // trade fulfiller address (acceptor)
	Disabled    bool               // disabled flag
	Completed   bool               // completed flag
}

// TradeList is a list of trades
type TradeList struct {
	Trades []Trade
}

func (cbl TradeList) String() string {
	output := "TradeList{"
	for _, cb := range cbl.Trades {
		output += cb.String()
		output += ",\n"
	}
	output += "}"
	return output
}

// NewTrade creates a new trade
func NewTrade(extraInfo string,
	coinInputs CoinInputList,      // coinOutputs CoinOutputList,
	itemInputs TradeItemInputList, // itemOutputs ItemOutputList,
	coinOutputs sdk.Coins,         // newly created param instead of coinOutputs and itemOutputs
	itemOutputs ItemList,
	sender sdk.AccAddress) Trade {
	trd := Trade{
		NodeVersion: SemVer{"0.0.1"},
		CoinInputs:  coinInputs,
		ItemInputs:  itemInputs,
		CoinOutputs: coinOutputs,
		ItemOutputs: itemOutputs,
		ExtraInfo:   extraInfo,
		Sender:      sender,
	}

	trd.ID = KeyGen(sender)
	return trd
}

func (trd *Trade) String() string {
	return fmt.Sprintf(`Trade{
		NodeVersion: %s,
		ID: %s,
		CoinInputs: %s,
		ItemInputs: %s,
		CoinOutputs: %s,
		ItemOutputs: %+v,
		ExtraInfo: %s,
		Sender: %+v,
	}`,
		trd.NodeVersion,
		trd.ID,
		trd.CoinInputs.String(),
		trd.ItemInputs.String(),
		trd.CoinOutputs.String(),
		trd.ItemOutputs,
		trd.ExtraInfo,
		trd.Sender,
	)
}

func TradeListToProto(trades []Trade) []*GetTradeResponse {
	var res []*GetTradeResponse
	for _, trade := range trades {
		res = append(res, &GetTradeResponse{
			NodeVersion: &trade.NodeVersion,
			ID:          trade.ID,
			CoinInputs:  &trade.CoinInputs,
			ItemInputs:  &trade.ItemInputs,
			CoinOutputs: trade.CoinOutputs,
			ItemOutputs: &trade.ItemOutputs,
			ExtraInfo:   trade.ExtraInfo,
			Sender:      trade.Sender.String(),
			FulFiller:   trade.FulFiller.String(),
			Disabled:    trade.Disabled,
			Completed:   trade.Completed,
		})
	}
	return res
}

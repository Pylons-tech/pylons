package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

// Trade is a construct to perform exchange of items and coins between users. Initiated by the sender and completed by
// the FulFiller
type Trade struct {
	Name       string
	ID         string // the recipe guid
	CoinInputs CoinInputList
	ItemInputs ItemInputList
	Entries    WeightedParamList
	ExtraInfo  string
	Sender     sdk.AccAddress
	FulFiller  sdk.AccAddress
	Completed  bool
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
func NewTrade(name, extraInfo string,
	coinInputs CoinInputList, // coinOutputs CoinOutputList,
	itemInputs ItemInputList, // itemOutputs ItemOutputList,
	entries WeightedParamList, // newly created param instead of coinOutputs and itemOutputs
	sender sdk.AccAddress) Trade {
	trd := Trade{
		Name:       name,
		CoinInputs: coinInputs,
		ItemInputs: itemInputs,
		Entries:    entries,
		ExtraInfo:  extraInfo,
		Sender:     sender,
	}

	trd.ID = trd.KeyGen()
	return trd
}

func (trd *Trade) String() string {
	return fmt.Sprintf(`Trade{
		Name: %s,
		ID: %s,
		CoinInputs: %s,
		ItemInputs: %s,
		Entries: %s
	}`, trd.Name,
		trd.ID,
		trd.CoinInputs.String(),
		trd.ItemInputs.String(),
		trd.Entries.String(),
	)
}

// KeyGen generates key for the store
func (trd Trade) KeyGen() string {
	id := uuid.New()
	return trd.Sender.String() + id.String()
}

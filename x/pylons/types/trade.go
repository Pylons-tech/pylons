package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

// Trade is
type Trade struct {
	Name        string
	ID          string // the recipe guid
	CoinInputs  CoinInputList
	ItemInputs  ItemInputList
	Entries     WeightedParamList
	Description string
	Sender      sdk.AccAddress
	FulFiller   sdk.AccAddress
	Completed   bool
}

// TradeList is a list of cookbook
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

// NewTrade creates a new recipe
func NewTrade(name, description string,
	coinInputs CoinInputList, // coinOutputs CoinOutputList,
	itemInputs ItemInputList, // itemOutputs ItemOutputList,
	entries WeightedParamList, // newly created param instead of coinOutputs and itemOutputs
	execTime int64, sender sdk.AccAddress) Trade {
	rcp := Trade{
		Name:        name,
		CoinInputs:  coinInputs,
		ItemInputs:  itemInputs,
		Entries:     entries,
		Description: description,
		Sender:      sender,
	}

	rcp.ID = rcp.KeyGen()
	return rcp
}

func (rcp *Trade) String() string {
	return fmt.Sprintf(`Trade{
		Name: %s,
		ID: %s,
		CoinInputs: %s,
		ItemInputs: %s,
		Entries: %s,
		ExecutionTime: %d,
	}`, rcp.ID,
		rcp.CoinInputs.String(),
		rcp.ItemInputs.String(),
		rcp.Entries.String())
}

// KeyGen generates key for the store
func (rcp Trade) KeyGen() string {
	id := uuid.New()
	return rcp.Sender.String() + id.String()
}

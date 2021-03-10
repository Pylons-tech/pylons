package types

import (
	"errors"
	"reflect"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeItem is a store key for item
const TypeItem = "item"

// SetTransferFee set item's TransferFee
func (it *Item) SetTransferFee(transferFee int64) {
	it.TransferFee = transferFee
}

// Max returns the larger of x or y.
func Max(x, y int64) int64 {
	if x < y {
		return y
	}
	return x
}

// Min returns the larger of x or y.
func Min(x, y int64) int64 {
	if x > y {
		return y
	}
	return x
}

// GetTransferFee set item's TransferFee
func (it Item) CalculateTransferFee() int64 {
	minItemTransferFee := config.Config.Fee.MinItemTransferFee
	maxItemTransferFee := config.Config.Fee.MaxItemTransferFee
	return Min(Max(it.TransferFee, minItemTransferFee), maxItemTransferFee)
}

// FindDouble is a function to get a double attribute from an item
func (it Item) FindDouble(key string) (float64, bool) {
	for _, v := range it.Doubles.List {
		if v.Key == key {
			return v.Value.Float(), true
		}
	}
	return 0, false
}

// FindDoubleKey is a function get double key index
func (it Item) FindDoubleKey(key string) (int, bool) {
	for i, v := range it.Doubles.List {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// FindLong is a function to get a long attribute from an item
func (it Item) FindLong(key string) (int, bool) {
	for _, v := range it.Longs.List {
		if v.Key == key {
			return int(v.Value), true
		}
	}
	return 0, false
}

// FindLongKey is a function to get long key index
func (it Item) FindLongKey(key string) (int, bool) {
	for i, v := range it.Longs.List {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// FindString is a function to get a string attribute from an item
func (it Item) FindString(key string) (string, bool) {
	for _, v := range it.Strings.List {
		if v.Key == key {
			return v.Value, true
		}
	}
	return "", false
}

// FindStringKey is a function to get string key index
func (it Item) FindStringKey(key string) (int, bool) {
	for i, v := range it.Strings.List {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// SetString set item's string attribute
func (it Item) SetString(key string, value string) bool {
	for i, v := range it.Strings.List {
		if v.Key == key {
			it.Strings.List[i].Value = value
			return true
		}
	}
	return false
}

// NewItem create a new item with an auto generated ID
func NewItem(cookbookID string, doubles DoubleKeyValueList, longs LongKeyValueList, strings StringKeyValueList, sender sdk.AccAddress, blockHeight int64, transferFee int64) Item {

	item := Item{
		NodeVersion: SemVer{"0.0.1"},
		CookbookID:  cookbookID,
		Doubles:     doubles,
		Longs:       longs,
		Strings:     strings,
		Sender:      sender.String(),
		// By default all items are tradable
		Tradable:    true,
		LastUpdate:  blockHeight,
		TransferFee: transferFee,
	}
	item.ID = KeyGen(sender)

	return item
}

// Equals compares two items
func (it Item) Equals(other Item) bool {
	return it.ID == other.ID &&
		reflect.DeepEqual(it.Doubles, other.Doubles) &&
		reflect.DeepEqual(it.Strings, other.Strings) &&
		reflect.DeepEqual(it.Longs, other.Longs) &&
		reflect.DeepEqual(it.CookbookID, other.CookbookID)
}

// MatchItemInput checks if the ItemInput matches the item
func (it Item) MatchItemInput(other ItemInput) bool {
	return reflect.DeepEqual(it.Doubles, other.Doubles) &&
		reflect.DeepEqual(it.Strings, other.Strings) &&
		reflect.DeepEqual(it.Longs, other.Longs)
}

// NewTradeError check if an item can be sent to someone else
func (it Item) NewTradeError() error {
	if !it.Tradable {
		return errors.New("Item Tradable flag is not set")
	}
	if it.OwnerRecipeID != "" {
		return errors.New("Item is owned by a recipe")
	}
	if it.OwnerTradeID != "" {
		return errors.New("Item is owned by a trade")
	}
	return nil
}

// FulfillTradeError check if an item can be sent to someone else
func (it Item) FulfillTradeError(tradeID string) error {
	if !it.Tradable {
		return errors.New("Item Tradable flag is not set")
	}
	if it.OwnerRecipeID != "" {
		return errors.New("Item is owned by a recipe")
	}
	if it.OwnerTradeID != tradeID {
		return errors.New("Item is not owned by the trade")
	}
	return nil
}

// NewRecipeExecutionError is a utility that shows if Recipe is compatible with recipe execution
func (it Item) NewRecipeExecutionError() error {
	if it.OwnerRecipeID != "" {
		return errors.New("Item is owned by a recipe")
	}
	if it.OwnerTradeID != "" {
		return errors.New("Item is owned by a trade")
	}
	return nil
}

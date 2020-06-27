package types

import (
	"errors"
	"fmt"
	"reflect"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeItem is a store key for item
const TypeItem = "item"

// DoubleKeyValue describes double key/value set
type DoubleKeyValue struct {
	Key   string
	Value FloatString
}

// LongKeyValue describes long key/value set
type LongKeyValue struct {
	Key   string
	Value int
}

// StringKeyValue describes string key/value set
type StringKeyValue struct {
	Key   string
	Value string
}

// Item is a tradable asset
type Item struct {
	ID      string
	Doubles []DoubleKeyValue
	Longs   []LongKeyValue
	Strings []StringKeyValue
	// as items are unique per cookbook
	CookbookID            string
	Sender                sdk.AccAddress
	OwnerRecipeID         string
	OwnerTradeID          string
	Tradable              bool
	LastUpdate            int64
	AdditionalTransferFee int64
}

// ItemList is a list of items
type ItemList []Item

// FindDouble is a function to get a double attribute from an item
func (it Item) FindDouble(key string) (float64, bool) {
	for _, v := range it.Doubles {
		if v.Key == key {
			return v.Value.Float(), true
		}
	}
	return 0, false
}

// FindDoubleKey is a function get double key index
func (it Item) FindDoubleKey(key string) (int, bool) {
	for i, v := range it.Doubles {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// FindLong is a function to get a long attribute from an item
func (it Item) FindLong(key string) (int, bool) {
	for _, v := range it.Longs {
		if v.Key == key {
			return v.Value, true
		}
	}
	return 0, false
}

// FindLongKey is a function to get long key index
func (it Item) FindLongKey(key string) (int, bool) {
	for i, v := range it.Longs {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// FindString is a function to get a string attribute from an item
func (it Item) FindString(key string) (string, bool) {
	for _, v := range it.Strings {
		if v.Key == key {
			return v.Value, true
		}
	}
	return "", false
}

// FindStringKey is a function to get string key index
func (it Item) FindStringKey(key string) (int, bool) {
	for i, v := range it.Strings {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// SetString set item's string attribute
func (it Item) SetString(key string, value string) bool {
	for i, v := range it.Strings {
		if v.Key == key {
			it.Strings[i].Value = value
			return true
		}
	}
	return false
}

func (it Item) String() string {
	return fmt.Sprintf(`
	Item{ 
		ID: %s,
		Sender: %s,
		Doubles: %+v,
		Longs: %+v,
		Strings: %+v,
		CookbookID: %+v,
	}`, it.ID, it.Sender, it.Doubles, it.Longs, it.Strings, it.CookbookID)
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

// NewItem create a new item with an auto generated ID
func NewItem(cookbookID string, doubles []DoubleKeyValue, longs []LongKeyValue, strings []StringKeyValue, sender sdk.AccAddress, BlockHeight int64, additionalTransferFee int64) *Item {
	item := &Item{
		CookbookID: cookbookID,
		Doubles:    doubles,
		Longs:      longs,
		Strings:    strings,
		Sender:     sender,
		// By default all items are tradable
		Tradable:              true,
		LastUpdate:            BlockHeight,
		AdditionalTransferFee: additionalTransferFee,
	}
	item.ID = KeyGen(sender)
	return item
}

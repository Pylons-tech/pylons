package types

import (
	"fmt"
	"reflect"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

type DoubleKeyValue struct {
	Key   string
	Value FloatString
}

type LongKeyValue struct {
	Key   string
	Value int
}

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
	CookbookID string
	Sender     sdk.AccAddress
}

// ItemList is a list of items
type ItemList []Item

func (it Item) FindDouble(key string) (float64, bool) {
	for _, v := range it.Doubles {
		if v.Key == key {
			return v.Value.Float(), true
		}
	}
	return 0, false
}

func (it Item) FindLong(key string) (int, bool) {
	for _, v := range it.Longs {
		if v.Key == key {
			return v.Value, true
		}
	}
	return 0, false
}

func (it Item) FindString(key string) (string, bool) {
	for _, v := range it.Strings {
		if v.Key == key {
			return v.Value, true
		}
	}
	return "", false
}

func (it Item) SetString(key string, value string) bool {
	for i, v := range it.Strings {
		if v.Key == key {
			it.Strings[i].Value = value
			return true
		}
	}
	return false
}

// KeyGen generates key for the store
func (it Item) KeyGen() string {
	id := uuid.New()
	return it.Sender.String() + id.String()
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
		reflect.DeepEqual(it.Longs, other.Longs)
}

// NewItem create a new item with an auto generated ID
func NewItem(cookbookID string, doubles []DoubleKeyValue, longs []LongKeyValue, strings []StringKeyValue, sender sdk.AccAddress) *Item {
	item := &Item{
		CookbookID: cookbookID,
		Doubles:    doubles,
		Longs:      longs,
		Strings:    strings,
		Sender:     sender,
	}
	item.ID = item.KeyGen()
	return item
}

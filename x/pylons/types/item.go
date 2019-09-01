package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

// Item is a tradable asset
type Item struct {
	ID      string
	Doubles map[string]float64
	Longs   map[string]int
	Strings map[string]string
	// as items are unique per cookbook
	CookbookID string
	Sender     sdk.AccAddress
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

// NewItem create a new item with an auto generated ID
func NewItem(cookbookID string, doubles map[string]float64, longs map[string]int, strings map[string]string, sender sdk.AccAddress) *Item {
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

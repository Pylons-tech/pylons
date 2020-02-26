package types

// CatalystItem is the item used as catalyst
type CatalystItem struct {
	Item `json:",inline"`
	// the chance of an item to be lost in %
	LostPerCent int
}

// CatalystItemList is a list of CatalystItems for convinience
type CatalystItemList []CatalystItem

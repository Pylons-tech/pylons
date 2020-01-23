package types

import "fmt"

// CatalystItemInput is the item input used for catalyst kind of items
type CatalystItemInput struct {
	ItemInput `json:",inline"`
	// If this is set to true then
	Required bool `json:"required"`
}

// CatalystItemInputList is a list of CatalystItemInputs for convinience
type CatalystItemInputList []CatalystItemInput

func (ciil CatalystItemInputList) String() string {
	itm := "CatalystItemInputList{"

	for _, input := range ciil {
		itm += fmt.Sprintf("%+v", input) + ",\n"
	}

	itm += "}"
	return itm
}

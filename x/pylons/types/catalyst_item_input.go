package types

import "fmt"

// CatalystItemInput is the item input used for catalyst kind of items
type CatalystItemInput struct {
	ItemInput `json:",inline"`
	// the chance of an item to be lost in %
	LostPerCent int
}

// CatalystItemInputList is a list of CatalystItemInputs for convinience
type CatalystItemInputList []CatalystItemInput

// Validate checks the values of the catalyst item list
func (ciil CatalystItemInputList) Validate() error {
	for _, cii := range ciil {
		if cii.LostPerCent < 0 || cii.LostPerCent > 100 {
			return fmt.Errorf("the lost percentage cannot be more then 100 or less then 0")
		}
	}
	return nil
}

func (ciil CatalystItemInputList) String() string {
	itm := "CatalystItemInputList{"

	for _, input := range ciil {
		itm += fmt.Sprintf("%+v", input) + ",\n"
	}

	itm += "}"
	return itm
}

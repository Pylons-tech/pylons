package types

import (
	"errors"
	"fmt"
)

// ItemInput is a wrapper struct for Item for recipes
type ItemInput struct {
	Doubles DoubleInputParamList
	Longs   LongInputParamList
	Strings StringInputParamList
}

// Matches checks if all the constraint match the given item
func (ii ItemInput) Matches(item Item) bool {

	for _, param := range ii.Doubles {
		double, ok := item.FindDouble(param.Key)
		if !ok {
			return false
		}

		if !param.Has(double) {
			return false
		}

	}

	for _, param := range ii.Longs {
		long, ok := item.FindLong(param.Key)
		if !ok {
			return false
		}

		if !param.Has(long) {
			return false
		}
	}

	for _, param := range ii.Strings {
		str, ok := item.FindString(param.Key)
		if !ok {
			return false
		}
		if str != param.Value {
			return false
		}
	}

	return true
}

// ItemInputList is a list of ItemInputs for convinience
type ItemInputList []ItemInput

func (iil ItemInputList) String() string {
	itm := "ItemInputList{"

	for _, input := range iil {
		itm += fmt.Sprintf("%+v", input) + ",\n"
	}

	itm += "}"
	return itm
}

// Validate is a function to check ItemInputList is valid
func (iil ItemInputList) Validate() error {
	return nil
}

// TradeItemInput is a wrapper struct for Item for trades
type TradeItemInput struct {
	ItemInput
	CookbookID string
}

// Matches checks if all the constraint match the given item
func (tii TradeItemInput) Matches(item Item) bool {
	if item.CookbookID != tii.CookbookID {
		return false
	}
	return tii.ItemInput.Matches(item)
}

// TradeItemInputList is a list of ItemInputs for convinience
type TradeItemInputList []TradeItemInput

func (tiil TradeItemInputList) String() string {
	itm := "TradeItemInputList{"

	for _, input := range tiil {
		itm += fmt.Sprintf("%+v", input) + ",\n"
	}

	itm += "}"
	return itm
}

// Validate is a function to check ItemInputList is valid
func (tiil TradeItemInputList) Validate() error {
	for _, ii := range tiil {
		if ii.CookbookID == "" {
			return errors.New("There should be no empty cookbook ID inputs for trades")
		}
	}
	return nil
}

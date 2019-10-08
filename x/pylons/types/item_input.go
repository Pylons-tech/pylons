package types

import "fmt"

// ItemInput is a wrapper struct for Item for recipes
type ItemInput struct {
	Doubles DoubleInputParamList
	Longs   LongInputParamList
	Strings StringInputParamList
}

// Matches checks if all the constraint match the given item
func (ii ItemInput) Matches(item Item) bool {

	for key, value := range ii.Doubles {
		double, ok := item.Doubles[key]
		if !ok {
			return false
		}

		if !value.Has(double) {
			return false
		}

	}

	for key, value := range ii.Longs {
		long, ok := item.Longs[key]
		if !ok {
			return false
		}

		if !value.Has(long) {
			return false
		}
	}

	for key, value := range ii.Strings {
		str, ok := item.Strings[key]
		if !ok {
			return false
		}
		if str != value.Value {
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

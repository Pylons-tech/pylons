package types

import "fmt"

// ItemInput is a wrapper struct for Item for recipes
type ItemInput struct {
	Doubles DoubleParamMap
	Longs   LongParamMap
	Strings StringParamMap
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

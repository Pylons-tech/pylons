package types

// ItemInput is a wrapper struct for Item for recipes
type ItemInput struct {
	*Item
}

// ItemInputList is a list of ItemInputs for convinience
type ItemInputList []ItemInput

func (iil ItemInputList) String() string {
	itm := "ItemInputList{"

	for _, input := range iil {
		itm += input.String() + ",\n"
	}

	itm += "}"
	return itm
}

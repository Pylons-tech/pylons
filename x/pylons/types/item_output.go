package types

// ItemOutput is a wrapper struct to items for recipes
type ItemOutput struct {
	*Item
}

// ItemOutputList is a list of Item outputs
type ItemOutputList []ItemOutput

func (iol ItemOutputList) String() string {
	itm := "ItemOutputList{"

	for _, output := range iol {
		itm += output.String() + ",\n"
	}

	itm += "}"
	return itm
}

package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// ItemOutput models the continuum of valid outcomes for item generation in recipes
type ItemOutput struct {
	Doubles DoubleParamMap
	Longs   LongParamMap
	Strings StringParamMap
}

// ItemOutputList is a list of Item outputs
type ItemOutputList []ItemOutput

func (io ItemOutput) Item(cookbook string, sender sdk.AccAddress) *Item {
	return NewItem(cookbook, io.Doubles.Actualize(), io.Longs.Actualize(), io.Strings.Actualize(), sender)
}

func (iol ItemOutputList) String() string {
	itm := "ItemOutputList{"

	for _, output := range iol {
		itm += fmt.Sprintf("%+v", output) + ",\n"
	}

	itm += "}"
	return itm
}

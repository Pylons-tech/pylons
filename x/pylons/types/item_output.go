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
	Weight  int
}

func (io ItemOutput) String() string {
	return fmt.Sprintf("%+v", io)
}

func (io ItemOutput) GetWeight() int {
	return io.Weight
}

func (io ItemOutput) Item(cookbook string, sender sdk.AccAddress) *Item {
	return NewItem(cookbook, io.Doubles.Actualize(), io.Longs.Actualize(), io.Strings.Actualize(), sender)
}

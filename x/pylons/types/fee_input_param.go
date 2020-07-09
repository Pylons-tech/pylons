package types

import (
	"fmt"
)

// FeeInputParam describes the bounds on an item input/output parameter of type int64
type FeeInputParam struct {
	MinValue int64
	MaxValue int64
}

func (lp FeeInputParam) String() string {
	return fmt.Sprintf(`
	FeeInputParam{ 
		MinValue: %d,
		MaxValue: %d,
	}`, lp.MinValue, lp.MaxValue)
}

// Has validate if input is between min max range
func (lp FeeInputParam) Has(input int64) bool {
	if lp.MinValue == 0 && lp.MaxValue == 0 {
		return true
	}
	return input >= lp.MinValue && input <= lp.MaxValue
}

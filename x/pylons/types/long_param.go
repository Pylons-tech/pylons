package types

import (
	"fmt"
)

// LongParam describes the bounds on an item input/output parameter of type int64
type LongParam struct {
	// The minimum legal value of this parameter.
	MinValue int
	// The maximum legal value of this parameter.
	MaxValue int
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate FloatString
}

// LongParamMap is a map of string:LongParam
type LongParamMap map[string]LongParam

func (lp LongParam) String() string {
	return fmt.Sprintf(`
	LongParam{ 
		MinValue: %d,
		MaxValue: %d,
		Rate: %+v,
	}`, lp.MinValue, lp.MaxValue, lp.Rate)
}

func (lpm LongParamMap) String() string {
	lp := "LongParamMap{"

	for name, param := range lpm {
		lp += name + ": " + param.String() + ",\n"
	}

	lp += "}"
	return lp
}

func (lpm LongParamMap) Actualize() map[string]int {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]int)
	for name, param := range lpm {
		m[name] = int((param.MinValue + param.MaxValue) / 2)
	}
	return m
}

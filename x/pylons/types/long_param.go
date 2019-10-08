package types

import (
	"fmt"
)

// LongParam describes the bounds on an item input/output parameter of type int64
type LongParam struct {
	Key string

	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate FloatString
	IntWeightTable
}

// LongParamList is a list of LongParam
type LongParamList []LongParam

func (lp LongParam) String() string {
	return fmt.Sprintf(`
	LongParam{ 
		IntWeightTable: %+v,
		Rate: %+v,
	}`, lp.IntWeightTable, lp.Rate)
}

func (lpm LongParamList) String() string {
	lp := "LongParamList{"

	for name, param := range lpm {
		lp += name + ": " + param.String() + ",\n"
	}

	lp += "}"
	return lp
}

// Actualize builds the params
func (lpm LongParamList) Actualize() map[string]int {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]int)
	for name, param := range lpm {
		m[name] = param.Generate()
	}
	return m
}

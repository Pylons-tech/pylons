package types

import (
	"fmt"
	"strconv"
)

// LongParam describes the bounds on an item input/output parameter of type int64
type LongParam struct {
	// The minimum legal value of this parameter.
	MinValue     int64
	// The maximum legal value of this parameter.
	MaxValue     int64
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate         float64
}
// LongParamMap is a map of string:LongParam
type LongParamMap map[string]LongParam

func (lp LongParam) String() string {
	return fmt.Sprintf(`
	LongParam{ 
		MinValue: %s,
		MaxValue: %s,
		Rate: %+v,
	}`, strconv.FormatInt(lp.MinValue, 10), strconv.FormatInt(lp.MaxValue, 10), strconv.FormatFloat(lp.Rate, 'f', -1, 64))
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
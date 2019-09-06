package types

import (
	"fmt"
	"strconv"
)

// DoubleParam describes the bounds on an item input/output parameter of type float64
type DoubleParam struct {
	// The minimum legal value of this parameter.
	MinValue     float64
	// The maximum legal value of this parameter.
	MaxValue     float64
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate         float64
}

// DoubleParamMap is a map of string:DoubleParam
type DoubleParamMap map[string]DoubleParam

func (dp DoubleParam) String() string {
	return fmt.Sprintf(`
	DoubleParam{ 
		MinValue: %s,
		MaxValue: %s,
		Rate: %+v,
	}`, strconv.FormatFloat(dp.MinValue, 'f', -1, 64), strconv.FormatFloat(dp.MaxValue, 'f', -1, 64), strconv.FormatFloat(dp.Rate, 'f', -1, 64))
}

func (dpm DoubleParamMap) String() string {
	dp := "DoubleParamMap{"

	for name, param := range dpm {
		dp += name + ": " + param.String() + ",\n"
	}

	dp += "}"
	return dp
}

func (dpm DoubleParamMap) Actualize() map[string]float64 {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]float64)
	for name, param := range dpm {
		m[name] = (param.MinValue + param.MaxValue) / 2
	}
	return m
}
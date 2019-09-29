package types

import (
	"fmt"
)

// DoubleParam describes the bounds on an item input/output parameter of type float64
type DoubleParam struct {
	DoubleWeightTable
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate FloatString
}

// DoubleParamMap is a map of string:DoubleParam
type DoubleParamMap map[string]DoubleParam

func (dp DoubleParam) String() string {
	return fmt.Sprintf(`
	DoubleParam{ 
		DoubleWeightTable: %+v
		Rate: %+v,
	}`, dp.DoubleWeightTable, dp.Rate)
}

func (dpm DoubleParamMap) String() string {
	dp := "DoubleParamMap{"

	for name, param := range dpm {
		dp += name + ": " + param.String() + ",\n"
	}

	dp += "}"
	return dp
}

// Actualize creates a map from the float64
func (dpm DoubleParamMap) Actualize() map[string]float64 {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]float64)
	for name, param := range dpm {
		m[name] = param.Generate()
	}
	return m
}

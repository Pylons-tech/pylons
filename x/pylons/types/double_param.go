package types

import (
	"fmt"
)

// DoubleParam describes the bounds on an item input/output parameter of type float64
type DoubleParam struct {
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate FloatString
	Key  string
	DoubleWeightTable
}

// DoubleParamList is a list of DoubleParam
type DoubleParamList []DoubleParam

func (dp DoubleParam) String() string {
	return fmt.Sprintf(`
	DoubleParam{ 
		DoubleWeightTable: %+v
		Rate: %+v,
	}`, dp.DoubleWeightTable, dp.Rate)
}

func (dpm DoubleParamList) String() string {
	dp := "DoubleParamList{"

	for name, param := range dpm {
		dp += name + ": " + param.String() + ",\n"
	}

	dp += "}"
	return dp
}

// Actualize creates a map from the float64
func (dpm DoubleParamList) Actualize() map[string]float64 {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]float64)
	for name, param := range dpm {
		m[name] = param.Generate()
	}
	return m
}

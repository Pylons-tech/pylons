package types

import (
	"fmt"
)

// DoubleInputParam describes the bounds on an item input/output parameter of type float64
type DoubleInputParam struct {
	DoubleWeightTable
}

// DoubleInputParamMap is a map of string:DoubleInputParam
type DoubleInputParamMap map[string]DoubleInputParam

func (dp DoubleInputParam) String() string {
	return fmt.Sprintf(`
	DoubleInputParam{ 
		DoubleWeightTable: %+v,
	}`, dp.DoubleWeightTable)
}

func (dpm DoubleInputParamMap) String() string {
	dp := "DoubleInputParamMap{"

	for name, param := range dpm {
		dp += name + ": " + param.String() + ",\n"
	}

	dp += "}"
	return dp
}

// Actualize creates a map from the float64
func (dpm DoubleInputParamMap) Actualize() map[string]float64 {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]float64)
	for name, param := range dpm {
		m[name] = param.Generate()
	}
	return m
}

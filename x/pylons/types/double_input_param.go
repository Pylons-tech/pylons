package types

import (
	"fmt"
)

// DoubleInputParam describes the bounds on an item input/output parameter of type float64
type DoubleInputParam struct {
	Key string
	DoubleWeightTable
}

// DoubleInputParamList is a map of string:DoubleInputParam
type DoubleInputParamList []DoubleInputParam

func (dp DoubleInputParam) String() string {
	return fmt.Sprintf(`
	DoubleInputParam{ 
		DoubleWeightTable: %+v,
	}`, dp.DoubleWeightTable)
}

func (dpm DoubleInputParamList) String() string {
	dp := "DoubleInputParamList{"

	for _, param := range dpm {
		dp += param.Key + ": " + param.String() + ",\n"
	}

	dp += "}"
	return dp
}

// Actualize creates a map from the float64
func (dpm DoubleInputParamList) Actualize() map[string]float64 {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]float64)
	for _, param := range dpm {
		m[param.Key] = param.Generate()
	}
	return m
}

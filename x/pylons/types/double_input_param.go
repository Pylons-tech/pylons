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

// Actualize creates a (key, value) list from ParamList
func (dpm DoubleInputParamList) Actualize() []DoubleKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []DoubleKeyValue
	for _, param := range dpm {
		m = append(m, DoubleKeyValue{
			Key:   param.Key,
			Value: ToFloatString(param.Generate()),
		})
	}
	return m
}

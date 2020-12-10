package types

import (
	"fmt"
)

// DoubleInputParam describes the bounds on an item input/output parameter of type float64
type DoubleInputParam struct {
	Key string
	// The minimum legal value of this parameter.
	MinValue FloatString
	// The maximum legal value of this parameter.
	MaxValue FloatString
}

// DoubleInputParamList is a list of DoubleInputParam
type DoubleInputParamList []DoubleInputParam

func (dp DoubleInputParam) String() string {
	return fmt.Sprintf(`
	DoubleInputParam{
		MinValue: %+v,
		MaxValue: %+v,
	}`, dp.MinValue, dp.MaxValue)
}

// Has check if an input is between double input param range
func (dp DoubleInputParam) Has(input float64) bool {
	return input >= dp.MinValue.Float() && input <= dp.MaxValue.Float()
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
			Value: ToFloatString((param.MinValue.Float() + param.MaxValue.Float()) / 2),
		})
	}
	return m
}

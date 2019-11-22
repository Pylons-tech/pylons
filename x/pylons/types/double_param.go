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

	for _, param := range dpm {
		dp += param.Key + ": " + param.String() + ",\n"
	}

	dp += "}"
	return dp
}

// Actualize creates a (key, value) list from ParamList
func (dpm DoubleParamList) Actualize() ([]DoubleKeyValue, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []DoubleKeyValue
	for _, param := range dpm {
		val, err := param.Generate()
		if err != nil {
			return m, err
		}
		m = append(m, DoubleKeyValue{
			Key:   param.Key,
			Value: ToFloatString(val),
		})
	}
	return m, nil
}

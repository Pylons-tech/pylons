package types

import (
	"fmt"

	"github.com/google/cel-go/cel"
)

// DoubleParam describes the bounds on an item input/output parameter of type float64
type DoubleParam struct {
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate FloatString
	Key  string
	DoubleWeightTable
	// When program is not empty, DoubleWeightTable is ignored
	Program string
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
func (dpm DoubleParamList) Actualize(env cel.Env, variables map[string]interface{}) ([]DoubleKeyValue, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []DoubleKeyValue
	for _, param := range dpm {
		if len(param.Program) > 0 {
			CheckAndExecuteProgram(env, variables, param.Program)
		}
		val, err := param.Generate()
		// TODO if param.Program is available then need to use that
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

package types

import (
	"fmt"
	"math"
	"reflect"
	"strconv"

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

var floatType = reflect.TypeOf(float64(0))
var stringType = reflect.TypeOf("")

func getFloat(unk interface{}) (float64, error) {
	switch i := unk.(type) {
	case float64:
		return i, nil
	case float32:
		return float64(i), nil
	case int64:
		return float64(i), nil
	case int32:
		return float64(i), nil
	case int:
		return float64(i), nil
	case uint64:
		return float64(i), nil
	case uint32:
		return float64(i), nil
	case uint:
		return float64(i), nil
	case string:
		return strconv.ParseFloat(i, 64)
	default:
		v := reflect.ValueOf(unk)
		v = reflect.Indirect(v)
		if v.Type().ConvertibleTo(floatType) {
			fv := v.Convert(floatType)
			return fv.Float(), nil
		} else if v.Type().ConvertibleTo(stringType) {
			sv := v.Convert(stringType)
			s := sv.String()
			return strconv.ParseFloat(s, 64)
		} else {
			return math.NaN(), fmt.Errorf("Can't convert %v to float64", v.Type())
		}
	}
}

// Actualize creates a (key, value) list from ParamList
func (dpm DoubleParamList) Actualize(env cel.Env, variables map[string]interface{}) ([]DoubleKeyValue, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []DoubleKeyValue
	for _, param := range dpm {
		var val float64
		var err error

		if len(param.Program) > 0 {
			refVal, refErr := CheckAndExecuteProgram(env, variables, param.Program)
			if refErr != nil {
				return m, refErr
			}
			val, err = getFloat(refVal.Value())
		} else {
			val, err = param.Generate()
		}
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

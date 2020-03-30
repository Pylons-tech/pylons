package types

import (
	"fmt"
)

// LongParam describes the bounds on an item input/output parameter of type int64
type LongParam struct {
	Key string

	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate FloatString
	IntWeightTable
	// When program is not empty, IntWeightTable is ignored
	Program string
}

// LongParamList is a list of LongParam
type LongParamList []LongParam

func (lp LongParam) String() string {
	return fmt.Sprintf(`
	LongParam{ 
		IntWeightTable: %+v,
		Rate: %+v,
	}`, lp.IntWeightTable, lp.Rate)
}

func (lpm LongParamList) String() string {
	lp := "LongParamList{"

	for _, param := range lpm {
		lp += param.Key + ": " + param.String() + ",\n"
	}

	lp += "}"
	return lp
}

// Actualize builds the params
func (lpm LongParamList) Actualize(ec CelEnvCollection) ([]LongKeyValue, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []LongKeyValue
	for _, param := range lpm {
		var val int
		var err error

		if len(param.Program) > 0 {
			val, err = ec.EvalInt(param.Program)
		} else {
			val, err = param.Generate()
		}
		if err != nil {
			return m, err
		}
		m = append(m, LongKeyValue{
			Key:   param.Key,
			Value: val,
		})
	}
	return m, nil
}

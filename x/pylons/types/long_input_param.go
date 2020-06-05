package types

import (
	"fmt"
)

// LongInputParam describes the bounds on an item input/output parameter of type int64
type LongInputParam struct {
	Key      string
	MinValue int
	MaxValue int
}

// LongInputParamList is a list of LongInputParam
type LongInputParamList []LongInputParam

func (lp LongInputParam) String() string {
	return fmt.Sprintf(`
	LongInputParam{ 
		MinValue: %d,
		MaxValue: %d,
	}`, lp.MinValue, lp.MaxValue)
}

// Has validate if input is between min max range
func (lp LongInputParam) Has(input int) bool {
	return input >= lp.MinValue && input <= lp.MaxValue
}

func (lpm LongInputParamList) String() string {
	lp := "LongInputParamList{"

	for _, param := range lpm {
		lp += param.Key + ": " + param.String() + ",\n"
	}

	lp += "}"
	return lp
}

// Actualize generate a value from range
func (lpm LongInputParamList) Actualize() []LongKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []LongKeyValue
	for _, param := range lpm {
		m = append(m, LongKeyValue{
			Key:   param.Key,
			Value: (param.MinValue + param.MaxValue) / 2,
		})
	}
	return m
}

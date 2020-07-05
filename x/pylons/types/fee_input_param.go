package types

import (
	"fmt"
)

// FeeInputParam describes the bounds on an item input/output parameter of type int64
type FeeInputParam struct {
	MinValue int
	MaxValue int
}

func (lp FeeInputParam) String() string {
	return fmt.Sprintf(`
	FeeInputParam{ 
		MinValue: %d,
		MaxValue: %d,
	}`, lp.MinValue, lp.MaxValue)
}

// Has validate if input is between min max range
func (lp FeeInputParam) Has(input int) bool {
	if lp.MinValue == 0 && lp.MaxValue == 0 {
		return true
	}
	return input >= lp.MinValue && input <= lp.MaxValue
}

// // Actualize generate a value from range
// func (lpm FeeInputParamList) Actualize() []LongKeyValue {
// 	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
// 	var m []LongKeyValue
// 	for _, param := range lpm {
// 		m = append(m, LongKeyValue{
// 			Key:   param.Key,
// 			Value: (param.MinValue + param.MaxValue) / 2,
// 		})
// 	}
// 	return m
// }

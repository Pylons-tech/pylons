package types

import (
	"fmt"
)

// LongInputParam describes the bounds on an item input/output parameter of type int64
type LongInputParam struct {
	WeightTable
}

type WeightTable struct {
	WeightRanges []WeightRange
}

type WeightRange struct {
	Lower  int
	Upper  int
	Weight int
}

// LongInputParamMap is a map of string:LongInputParam
type LongInputParamMap map[string]LongInputParam

func (lp LongInputParam) String() string {
	return fmt.Sprintf(`
	LongInputParam{ 

	}`)
}

func (lpm LongInputParamMap) String() string {
	lp := "LongInputParamMap{"

	for name, param := range lpm {
		lp += name + ": " + param.String() + ",\n"
	}

	lp += "}"
	return lp
}

func (lpm LongInputParamMap) Actualize() map[string]int {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]int)
	for name, param := range lpm {
		m[name] = int((param.MinValue + param.MaxValue) / 2)
	}
	return m
}

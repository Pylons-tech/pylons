package types

import (
	"fmt"
)

// LongInputParam describes the bounds on an item input/output parameter of type int64
type LongInputParam struct {
	Key string
	IntWeightTable
}

// LongInputParamList is a list of LongInputParam
type LongInputParamList []LongInputParam

func (lp LongInputParam) String() string {
	return fmt.Sprintf(`
	LongInputParam{ 
		%+v
	}`, lp.IntWeightTable)
}

func (lpm LongInputParamList) String() string {
	lp := "LongInputParamList{"

	for name, param := range lpm {
		lp += name + ": " + param.String() + ",\n"
	}

	lp += "}"
	return lp
}

func (lpm LongInputParamList) Actualize() map[string]int {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]int)
	for name, param := range lpm {
		m[name] = param.Generate()
	}
	return m
}

package types

import (
	"fmt"
	"strconv"
)

// LongInputParam describes the bounds on an item input/output parameter of type int64
type LongInputParam struct {
	// The minimum legal value of this parameter.
	MinValue int64
	// The maximum legal value of this parameter.
	MaxValue int64
}

// LongInputParamMap is a map of string:LongInputParam
type LongInputParamMap map[string]LongInputParam

func (lp LongInputParam) String() string {
	return fmt.Sprintf(`
	LongInputParam{ 
		MinValue: %s,
		MaxValue: %s,
	}`, strconv.FormatInt(lp.MinValue, 10), strconv.FormatInt(lp.MaxValue, 10))
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

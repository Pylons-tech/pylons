package types

import (
	"fmt"
)

// StringInputParam describes the bounds on an item input/output parameter of type int64
type StringInputParam struct {
	Key string
	// The value of the parameter
	Value string
}

// StringInputParamList is a list of StringInputParam
type StringInputParamList []StringInputParam

func (lp StringInputParam) String() string {
	return fmt.Sprintf(`
	StringInputParam{ 
		Value: %s,
	}`, lp.Value)
}

func (lpm StringInputParamList) String() string {
	lp := "StringInputParamList{"

	for _, param := range lpm {
		lp += param.Key + ": " + param.String() + ",\n"
	}

	lp += "}"
	return lp
}

func (lpm StringInputParamList) Actualize() []StringKeyValue {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []StringKeyValue
	for _, param := range lpm {
		m = append(m, StringKeyValue(param))
	}
	return m
}

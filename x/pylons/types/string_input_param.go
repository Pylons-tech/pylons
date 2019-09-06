package types

import (
	"fmt"
)

// StringInputParam describes the bounds on an item input/output parameter of type int64
type StringInputParam struct {
	// The value of the parameter
	Value string
}

// StringInputParamMap is a map of string:StringInputParam
type StringInputParamMap map[string]StringInputParam

func (lp StringInputParam) String() string {
	return fmt.Sprintf(`
	StringInputParam{ 
		Value: %s,
	}`, lp.Value)
}

func (lpm StringInputParamMap) String() string {
	lp := "StringInputParamMap{"

	for name, param := range lpm {
		lp += name + ": " + param.String() + ",\n"
	}

	lp += "}"
	return lp
}

func (lpm StringInputParamMap) Actualize() map[string]string {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]string)
	for name, param := range lpm {
		m[name] = param.Value
	}
	return m
}

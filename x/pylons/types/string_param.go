package types

import (
	"fmt"
)

// StringParam describes an item input/output parameter of type string
type StringParam struct {
	// The value of the parameter
	Value        string
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate         FloatString
}

// StringParamMap is a map of string:StringParam
type StringParamMap map[string]StringParam

func (sp StringParam) String() string {
	return fmt.Sprintf(`
	StringParam{ 
		Value: %s,
		Rate: %+v,
	}`, sp.Value, sp.Rate)
}

func (spm StringParamMap) String() string {
	sp := "StringParamMap{"

	for name, param := range spm {
		sp += name + ": " + param.String() + ",\n"
	}

	sp += "}"
	return sp
}

func (spm StringParamMap) Actualize() map[string]string {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]string)
	for name, param := range spm {
		m[name] = param.Value
	}
	return m
}
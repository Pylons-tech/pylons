package types

import (
	"fmt"
)

// StringParam describes an item input/output parameter of type string
type StringParam struct {
	Key string
	// The value of the parameter
	Value string
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate FloatString
}

// StringParamList is a list of StringParam
type StringParamList []StringParam

func (sp StringParam) String() string {
	return fmt.Sprintf(`
	StringParam{
		Value: %s,
		Rate: %+v,
	}`, sp.Value, sp.Rate)
}

func (spm StringParamList) String() string {
	sp := "StringParamList{"

	for _, param := range spm {
		sp += param.Key + ": " + param.String() + ",\n"
	}

	sp += "}"
	return sp
}

func (spm StringParamList) Actualize() map[string]string {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	m := make(map[string]string)
	for _, param := range spm {
		m[param.Key] = param.Value
	}
	return m
}

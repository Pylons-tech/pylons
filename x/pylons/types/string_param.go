package types

import (
	"fmt"
)

// StringParam describes an item input/output parameter of type string
type StringParam struct {
	// The value of the parameter
	Value        string
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate         float32
}

// StringParamList is a list of StringParams
type StringParamList []StringParam

func (sp StringParam) String() string {
	return fmt.Sprintf(`
	StringParam{ 
		Value: %s,
		Rate: %+v,
	}`, sp.Value, sp.Rate)
}

func (spl StringParamList) String() string {
	sp := "StringParamList{"

	for _, output := range spl {
		sp += output.String() + ",\n"
	}

	sp += "}"
	return sp
}

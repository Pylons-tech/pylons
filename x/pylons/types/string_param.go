package types

import (
	"fmt"

	"github.com/google/cel-go/cel"
)

// StringParam describes an item input/output parameter of type string
type StringParam struct {
	// The likelihood that this parameter is applied to the output item. Between 0.0 (exclusive) and 1.0 (inclusive).
	Rate  FloatString
	Key   string
	Value string
	// When program is not empty, Value is ignored
	Program string
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

func (spm StringParamList) Actualize(env cel.Env, variables map[string]interface{}, funcs cel.ProgramOption) ([]StringKeyValue, error) {
	// We don't have the ability to do random numbers in a verifiable way rn, so don't worry about it
	var m []StringKeyValue
	for _, param := range spm {
		var val string

		if len(param.Program) > 0 {
			refVal, refErr := CheckAndExecuteProgram(env, variables, funcs, param.Program)
			if refErr != nil {
				return m, refErr
			}
			val = fmt.Sprintf("%v", refVal.Value())
		} else {
			val = param.Value
		}
		m = append(m, StringKeyValue{
			Key:   param.Key,
			Value: val,
		})
	}
	return m, nil
}

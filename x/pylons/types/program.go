package types

import (
	"errors"
	"fmt"

	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/common/types/ref"
)

func CheckAndExecuteProgram(env cel.Env, variables map[string]interface{}, program string) (ref.Val, error) {
	parsed, issues := env.Parse(program)
	if issues != nil && issues.Err() != nil {
		return nil, errors.New("parse error: " + issues.Err().Error())
	}
	checked, issues := env.Check(parsed)
	if issues != nil && issues.Err() != nil {
		return nil, errors.New("type-check error: " + issues.Err().Error())
	}
	prg, err := env.Program(checked)
	if err != nil {
		return nil, errors.New("program construction error: " + err.Error())
	}
	out, details, err := prg.Eval(variables)
	fmt.Println(out, details)
	return out, nil
}

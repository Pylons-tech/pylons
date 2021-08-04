package types

import (
	"errors"
	"fmt"
	"math/rand"
	"strconv"

	"github.com/google/cel-go/cel"
	"github.com/google/cel-go/common/types/ref"
)


// CelEnvCollection struct manage cel program work flow
type CelEnvCollection struct {
	env       *cel.Env
	variables map[string]interface{}
	funcs     cel.ProgramOption
}

// NewCelEnvCollection generate a new CelEnvCollection
func NewCelEnvCollection(env *cel.Env, variables map[string]interface{}, funcs cel.ProgramOption) CelEnvCollection {
	return CelEnvCollection{env, variables, funcs}
}

// Eval calculate a value
func (ec *CelEnvCollection) Eval(program string) (ref.Val, error) {
	parsed, issues := ec.env.Parse(program)
	if issues != nil && issues.Err() != nil {
		return nil, errors.New("parse error: " + issues.Err().Error())
	}
	checked, issues := ec.env.Check(parsed)
	if issues != nil && issues.Err() != nil {
		return nil, errors.New("type-check error: " + issues.Err().Error())
	}
	prg, err := ec.env.Program(checked, ec.funcs)
	if err != nil {
		return nil, errors.New("program construction error: " + err.Error())
	}
	out, details, err := prg.Eval(ec.variables)
	fmt.Println("CelEnvCollection.Eval::", out, details, ec.variables)
	return out, err
}

// EvalInt64 calculate a value and convert to int64
func (ec *CelEnvCollection) EvalInt64(program string) (int64, error) {
	refVal, refErr := ec.Eval(program)
	if refErr != nil {
		return 0, refErr
	}
	val64, ok := refVal.Value().(int64)
	if !ok {
		return 0, errors.New("returned result from program is not convertable to int")
	}
	return val64, nil
}

// EvalInt calculate a value and convert to int
func (ec *CelEnvCollection) EvalInt(program string) (int, error) {
	val64, err := ec.EvalInt64(program)
	return int(val64), err
}

// EvalFloat64 calculate a value and convert to float64
func (ec *CelEnvCollection) EvalFloat64(program string) (float64, error) {
	refVal, refErr := ec.Eval(program)
	if refErr != nil {
		return 0, refErr
	}
	return getFloat(refVal.Value())
}

// EvalString calculate a value and convert to string
func (ec *CelEnvCollection) EvalString(program string) (string, error) {
	refVal, refErr := ec.Eval(program)
	if refErr != nil {
		return "", refErr
	}
	return fmt.Sprintf("%v", refVal.Value()), nil
}

// TODO convert weight uint64 to string?
// GetWeightInt calculate weight value using program
func (ol WeightedOutputs) GetWeightInt(ec CelEnvCollection) (int, error) {
	weightStr := strconv.FormatUint(ol.Weight, 10)
	refVal, refErr := ec.Eval(weightStr)
	if refErr != nil {
		return 0, refErr
	}

	val64, ok := refVal.Value().(int64)
	if !ok {
		return 0, errors.New("error converting weight value to int64")
	}
	if val64 < 0 {
		return 0, nil
	}
	return int(val64), nil
}

// Actualize generate result entries from WeightedOutputsList
func (wol WeightedOutputsList) Actualize(ec CelEnvCollection) ([]string, error) {

	if len(wol) == 0 {
		return nil, nil
	}

	lastWeight := 0
	weights := make([]int, 0, len(wol))
	for _, wp := range wol {
		w, err := wp.GetWeightInt(ec)
		if err != nil {
			return nil, err
		}
		lastWeight += w
		weights = append(weights, lastWeight)
	}

	if lastWeight == 0 {
		return nil, errors.New("total weight of weighted param list shouldn't be zero")
	}
	randWeight := rand.Intn(lastWeight)

	first := 0
	chosenIndex := -1
	for i, weight := range weights {
		if randWeight >= first && randWeight <= weight {
			chosenIndex = i
			break
		}
		first = weight
	}
	return wol[chosenIndex].EntryIDs, nil
}

// ProgramValidateBasic validate program
func ProgramValidateBasic(program string) error {
	if len(program) == 0 {
		return errors.New("length of program code shouldn't be 0")
	}
	return nil
}

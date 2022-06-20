package types

import (
	"errors"
	"fmt"
	"math/rand"

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

func (ec *CelEnvCollection) GetVariables() map[string]interface{} {
	return ec.variables
}

func (ec *CelEnvCollection) GetEnv() *cel.Env {
	return ec.env
}

func (ec *CelEnvCollection) GetFuncs() cel.ProgramOption {
	return ec.funcs
}

// Eval calculate a value
func (ec *CelEnvCollection) eval(program string) (ref.Val, error) {
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
	refVal, refErr := ec.eval(program)
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
	refVal, refErr := ec.eval(program)
	if refErr != nil {
		return 0, refErr
	}
	return getFloat(refVal.Value())
}

// EvalString calculate a value and convert to string
func (ec *CelEnvCollection) EvalString(program string) (string, error) {
	refVal, refErr := ec.eval(program)
	if refErr != nil {
		return "", refErr
	}
	return fmt.Sprintf("%v", refVal.Value()), nil
}

func sample(r float64, cdf []float64) int {
	bucket := 0
	for r > cdf[bucket] {
		bucket++
	}
	return bucket
}

// Actualize generate result entries from WeightedOutputsList
func (wol WeightedOutputsList) Actualize() ([]string, error) {
	if len(wol) == 0 {
		return nil, nil
	}

	// calculate CDF
	weightSum := uint64(0)
	cdf := make([]uint64, len(wol))
	for i, wp := range wol {
		weightSum += wp.Weight
		cdf[i] = weightSum
	}

	if weightSum == 0 {
		return nil, errors.New("total weight of weighted param list shouldn't be zero")
	}

	// normalize CDF
	normCDF := make([]float64, len(wol))
	for i, p := range cdf {
		normCDF[i] = float64(p) / float64(weightSum)
	}

	randWeight := rand.Float64()
	index := sample(randWeight, normCDF)

	return wol[index].EntryIds, nil
}

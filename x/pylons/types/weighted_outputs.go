package types

import (
	"errors"
	"math/rand"
)

type WeightedOutputsList []WeightedOutputs

// GetWeight calculate weight value using program
func (ol WeightedOutputs) GetWeightInt(ec CelEnvCollection) (int, error) {
	refVal, refErr := ec.Eval(ol.Weight)
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
	var weights []int
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

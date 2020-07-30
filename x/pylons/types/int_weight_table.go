package types

import (
	"errors"
	"math/rand"
)

// IntWeightTable describes weight loot table that produce int value
type IntWeightTable struct {
	WeightRanges []IntWeightRange
}

// IntWeightRange describes weight range that produce int value
type IntWeightRange struct {
	Lower  int
	Upper  int
	Weight int
}

// Has check if a number is under IntWeightRange
func (wr IntWeightRange) Has(number int) bool {
	return number >= wr.Lower && number < wr.Upper
}

// Generate uses the weight table to generate a random number. Its uses a 2 level random generation mechanism.
// E.g. 2 weight ranges are provided with values [100, 500  weight: 8] and [600, 800 weight: 2] so now we
// generate a random number from 0 to 10 and if its from 0 to 8 then selected range = [100, 500] else [600, 800].
// next we get a random number from the selected range and return that
func (wt *IntWeightTable) Generate() (int, error) {
	lastWeight := 0
	var weights []int
	for _, weightRange := range wt.WeightRanges {
		lastWeight += weightRange.Weight
		weights = append(weights, lastWeight)
	}
	if lastWeight == 0 {
		return 0, errors.New("total weight of IntWeightTable shouldn't be zero")
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
	// TODO this can be possible out of array range
	selectedWeightRange := wt.WeightRanges[chosenIndex]

	if selectedWeightRange.Upper > selectedWeightRange.Lower {
		return rand.Intn(selectedWeightRange.Upper-selectedWeightRange.Lower) + selectedWeightRange.Lower, nil
	}
	return selectedWeightRange.Lower, nil
}

// Has checks if any of the weight ranges has the number
func (wt *IntWeightTable) Has(number int) bool {
	for _, weightRange := range wt.WeightRanges {
		if weightRange.Has(number) {
			return true
		}
	}
	return false
}

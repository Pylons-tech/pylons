package types

import "math/rand"

type IntWeightTable struct {
	WeightRanges []IntWeightRange
}

type IntWeightRange struct {
	Lower  int
	Upper  int
	Weight int
}

func (wr IntWeightRange) Has(number int) bool {
	return number >= wr.Lower && number < wr.Upper
}

// Generate uses the weight table to generate a random number. Its uses a 2 level random generation mechanism.
// E.g. 2 weight ranges are provided with values [100, 500  weight: 8] and [600, 800 weight: 2] so now we
// generate a random number from 0 to 10 and if its from 0 to 8 then selected range = [100, 500] else [600, 800].
// next we get a random number from the selected range and return that
func (wt *IntWeightTable) Generate() int {
	lastWeight := 0
	var weights []int
	for _, weightRange := range wt.WeightRanges {
		lastWeight += weightRange.Weight
		weights = append(weights, lastWeight)
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
	selectedWeightRange := wt.WeightRanges[chosenIndex]

	return rand.Intn(selectedWeightRange.Upper-selectedWeightRange.Lower) + selectedWeightRange.Lower
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

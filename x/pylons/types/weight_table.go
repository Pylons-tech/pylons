package types

import "math/rand"

type WeightTable struct {
	WeightRanges []WeightRange
}

type WeightRange struct {
	Lower  int
	Upper  int
	Weight int
}

// Generate uses the weight table to generate a random number. Its uses a 2 level random generation mechanism.
// E.g. 2 weight ranges are provided with values [100, 500  weight: 8] and [600, 800 weight: 2] so now we
// generate a random number from 0 to 10 and if its from 0 to 8 then selected range = [100, 500] else [600, 800].
// next we get a random number from the selected range and return that
func (wt *WeightTable) Generate() int {
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
		if randWeight > first && randWeight <= weight {
			chosenIndex = i
			break
		}
		first = weight
	}
	selectedWeightRange := wt.WeightRanges[chosenIndex]

	return rand.Intn(selectedWeightRange.Upper-selectedWeightRange.Lower) + selectedWeightRange.Lower
}

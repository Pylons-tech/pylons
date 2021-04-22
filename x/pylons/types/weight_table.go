package types

import (
	"errors"
	"fmt"
	"math/rand"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Has check if an input is between double weight range
func (wr DoubleWeightRange) Has(number sdk.Dec) bool {
	return wr.Lower.GTE(number) && wr.Upper.LTE(number)
}

// Generate uses the weight table to generate a random number. Its uses a 2 int64 random generation mechanism.
// E.g. 2 weight ranges are provided with values [100.00, 500.00  weight: 8] and [600.00, 800.00 weight: 2] so now we
// generate a random number from 0 to 10 and if its from 0 to 8 then selected range = [100.00, 500.00] else [600.00, 800.00].
// next we get a random number from the selected range and return that
func (wt *DoubleWeightTable) Generate() (sdk.Dec, error) {
	var lastWeight int64 = 0
	var weights []int64
	for _, weightRange := range wt.WeightRanges {
		lastWeight += weightRange.Weight
		weights = append(weights, lastWeight)
	}
	if lastWeight == 0 {
		return sdk.NewDec(0), errors.New("total weight of DoubleWeightTable shouldn't be zero")
	}
	randWeight := rand.Int63n(lastWeight)

	var first int64 = 0
	chosenIndex := -1
	for i, weight := range weights {
		if randWeight >= first && randWeight < weight {
			chosenIndex = i
			break
		}
		first = weight
	}

	if chosenIndex < 0 || chosenIndex >= len(wt.WeightRanges) {
		return sdk.NewDec(0), errors.New("something went wrong generating random double value")
	}

	selectedWeightRange := wt.WeightRanges[chosenIndex]

	randDec, _ := sdk.NewDecFromStr(fmt.Sprintf("%v", rand.Float64()))
	return randDec.Mul(selectedWeightRange.Upper.Sub(selectedWeightRange.Lower)).Add(selectedWeightRange.Lower), nil
}

// Has checks if any of the weight ranges has the number
func (wt *DoubleWeightTable) Has(number sdk.Dec) bool {
	for _, weightRange := range wt.WeightRanges {
		if weightRange.Has(number) {
			return true
		}
	}
	return false
}

// Has check if a number is under IntWeightRange
func (wr IntWeightRange) Has(number int64) bool {
	return number >= wr.Lower && number < wr.Upper
}

// Generate uses the weight table to generate a random number. Its uses a 2 int64 random generation mechanism.
// E.g. 2 weight ranges are provided with values [100, 500  weight: 8] and [600, 800 weight: 2] so now we
// generate a random number from 0 to 10 and if its from 0 to 8 then selected range = [100, 500] else [600, 800].
// next we get a random number from the selected range and return that
func (wt *IntWeightTable) Generate() (int64, error) {
	var lastWeight int64 = 0
	var weights []int64
	for _, weightRange := range wt.WeightRanges {
		lastWeight += weightRange.Weight
		weights = append(weights, lastWeight)
	}
	if lastWeight == 0 {
		return 0, errors.New("total weight of IntWeightTable shouldn't be zero")
	}
	randWeight := rand.Int63n(lastWeight)

	var first int64 = 0
	chosenIndex := -1
	for i, weight := range weights {
		if randWeight >= first && randWeight < weight {
			chosenIndex = i
			break
		}
		first = weight
	}

	if chosenIndex < 0 || chosenIndex >= len(wt.WeightRanges) {
		return 0, errors.New("something went wrong generating random integer value")
	}

	selectedWeightRange := wt.WeightRanges[chosenIndex]

	if selectedWeightRange.Upper > selectedWeightRange.Lower {
		return rand.Int63n(selectedWeightRange.Upper-selectedWeightRange.Lower) + selectedWeightRange.Lower, nil
	}
	return selectedWeightRange.Lower, nil
}

// Has checks if any of the weight ranges has the number
func (wt *IntWeightTable) Has(number int) bool {
	for _, weightRange := range wt.WeightRanges {
		if weightRange.Has(int64(number)) {
			return true
		}
	}
	return false
}

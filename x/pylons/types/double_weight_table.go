package types

import (
	"errors"
	"fmt"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"math/rand"
)

// Has check if an input is between double weight range
func (wr DoubleWeightRange) Has(number sdk.Dec) bool {
	return wr.Lower.GTE(number) && wr.Upper.LTE(number)
}

// Generate uses the weight table to generate a random number. Its uses a 2 level random generation mechanism.
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

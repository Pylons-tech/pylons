package types

import (
	"errors"
	"fmt"
	"math/rand"

	"cosmossdk.io/math"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// Has check if an input is between double weight range
func (wr DoubleWeightRange) Has(number math.Int) bool {
	return wr.Lower.GTE(number) && wr.Upper.LTE(number)
}

// Generate uses the weight table to generate a random number. Its uses a 2 int64 random generation mechanism.
// E.g. 2 weight ranges are provided with values [100.00, 500.00  weight: 8] and [600.00, 800.00 weight: 2] so now we
// generate a random number from 0 to 10 and if its from 0 to 8 then selected range = [100.00, 500.00] else [600.00, 800.00].
// next we get a random number from the selected range and return that
func (wt DoubleWeightTable) Generate() (math.Int, error) {
	var lastWeight int64
	weights := make([]int64, len(wt))
	for i, weightRange := range wt {
		lastWeight += int64(weightRange.Weight)
		weights[i] = lastWeight
	}
	if lastWeight == 0 {
		return math.ZeroInt(), errors.New("total weight of DoubleWeightTable shouldn't be zero")
	}
	randWeight := rand.Int63n(lastWeight)

	var first int64
	chosenIndex := -1
	for i, weight := range weights {
		if randWeight >= first && randWeight < weight {
			chosenIndex = i
			break
		}
		first = weight
	}

	if chosenIndex < 0 || chosenIndex >= len(wt) {
		return math.ZeroInt(), errors.New("something went wrong generating random double value")
	}

	selectedWeightRange := wt[chosenIndex]

	if selectedWeightRange.Upper.Equal(selectedWeightRange.Lower) {
		return selectedWeightRange.Upper, nil
	}

	randNum := rand.Float64()
	randStr := fmt.Sprintf("%f", randNum)
	randDec, ok := math.NewIntFromString(randStr)
	if ok == false {
		var err error
		return selectedWeightRange.Lower, sdkerrors.Wrapf(err, "error creating random sdk.Int : float: %f, string %s", randNum, randStr)
	}
	return randDec.Mul(selectedWeightRange.Upper.Sub(selectedWeightRange.Lower)).Add(selectedWeightRange.Lower), nil
}

// Has checks if any of the weight ranges has the number
func (wt DoubleWeightTable) Has(number math.Int) bool {
	for _, weightRange := range wt {
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
func (wt IntWeightTable) Generate() (int64, error) {
	var lastWeight int64
	weights := make([]int64, len(wt))
	for i, weightRange := range wt {
		lastWeight += int64(weightRange.Weight)
		weights[i] = lastWeight
	}
	if lastWeight == 0 {
		return 0, errors.New("total weight of IntWeightTable shouldn't be zero")
	}
	randWeight := rand.Int63n(lastWeight)

	var first int64
	chosenIndex := -1
	for i, weight := range weights {
		if randWeight >= first && randWeight < weight {
			chosenIndex = i
			break
		}
		first = weight
	}

	if chosenIndex < 0 || chosenIndex >= len(wt) {
		return 0, errors.New("something went wrong generating random integer value")
	}

	selectedWeightRange := wt[chosenIndex]

	if selectedWeightRange.Upper == selectedWeightRange.Lower {
		return selectedWeightRange.Upper, nil
	}

	if selectedWeightRange.Upper > selectedWeightRange.Lower {
		return rand.Int63n(selectedWeightRange.Upper-selectedWeightRange.Lower) + selectedWeightRange.Lower, nil
	}
	return selectedWeightRange.Lower, nil
}

// Has checks if any of the weight ranges has the number
func (wt IntWeightTable) Has(number int) bool {
	for _, weightRange := range wt {
		if weightRange.Has(int64(number)) {
			return true
		}
	}
	return false
}

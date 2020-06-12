package handlers

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func errInternal(err error) error {

	return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
}

func marshalJSON(intf interface{}) (*sdk.Result, error) {
	mData, err := json.Marshal(intf)

	if err != nil {
		return nil, errInternal(err)
	}

	return &sdk.Result{Data: mData}, nil
}

// Contains is a utility function to find an int value from int array
func Contains(arr []int, it int) bool {
	for _, a := range arr {
		if a == it {
			return true
		}
	}
	return false
}

// Max returns the larger of x or y.
func Max(x, y int64) int64 {
	if x < y {
		return y
	}
	return x
}

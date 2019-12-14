package handlers

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func errInternal(err error) sdk.Result {

	return sdk.ErrInternal(err.Error()).Result()
}

func marshalJson(intf interface{}) sdk.Result {
	mData, err := json.Marshal(intf)

	if err != nil {
		return errInternal(err)
	}

	return sdk.Result{Data: mData}
}

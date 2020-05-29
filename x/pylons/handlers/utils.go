package handlers

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func errInternal(err error) error {

	return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
}

func marshalJson(intf interface{}) (*sdk.Result, error) {
	mData, err := json.Marshal(intf)

	if err != nil {
		return nil, errInternal(err)
	}

	return &sdk.Result{Data: mData}, nil
}

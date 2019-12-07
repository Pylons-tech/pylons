package handlers

import sdk "github.com/cosmos/cosmos-sdk/types"

func errInternal(err error) sdk.Result {

	return sdk.ErrInternal(err.Error()).Result()
}

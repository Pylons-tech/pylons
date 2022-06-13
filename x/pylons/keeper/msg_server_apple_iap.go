package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k msgServer) AppleIap(goCtx context.Context, msg *types.MsgAppleIap) (*types.MsgAppleIapResponse, error) {
	_ = sdk.UnwrapSDKContext(goCtx)

	// TODO: Handling the message
	err := types.ValidateApplePay(msg)
	if err != nil {
		return nil, err
	}

	return &types.MsgAppleIapResponse{}, nil
}

package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) FulfillTrade(goCtx context.Context, msg *types.MsgFulfillTrade) (*types.MsgFulfillTradeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// TODO: Handling the message
	_ = ctx

	return &types.MsgFulfillTradeResponse{}, nil
}

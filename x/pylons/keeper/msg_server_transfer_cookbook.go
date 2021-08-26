package keeper

import (
	"context"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) TransferCookbook(goCtx context.Context, msg *types.MsgTransferCookbook) (*types.MsgTransferCookbookResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// check if cookbook is currently owned by creator
	cookbook, found := k.Keeper.GetCookbook(ctx, msg.ID)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook not found")
	}

	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook not owned my message creator")
	}

	cookbook.Creator = msg.Recipient
	k.Keeper.SetCookbook(ctx, cookbook)

	// TODO should this event be more fleshed out?
	err := ctx.EventManager().EmitTypedEvent(&types.EventTransferCookbook{
		Sender:   msg.Creator,
		Receiver: cookbook.Creator,
		ID:       cookbook.ID,
	})

	return &types.MsgTransferCookbookResponse{}, err
}

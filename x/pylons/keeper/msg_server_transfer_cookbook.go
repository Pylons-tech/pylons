package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k msgServer) TransferCookbook(goCtx context.Context, msg *v1beta1.MsgTransferCookbook) (*v1beta1.MsgTransferCookbookResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// check if cookbook is currently owned by creator
	cookbook, found := k.Keeper.GetCookbook(ctx, msg.Id)
	if !found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook not found")
	}

	if cookbook.Creator != msg.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cookbook not owned my message creator")
	}

	cookbook.Creator = msg.Recipient
	creatorAddr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "invalid sender address")
	}
	k.Keeper.UpdateCookbook(ctx, cookbook, creatorAddr)

	err = ctx.EventManager().EmitTypedEvent(&v1beta1.EventTransferCookbook{
		Sender:   msg.Creator,
		Receiver: cookbook.Creator,
		Id:       cookbook.Id,
	})

	return &v1beta1.MsgTransferCookbookResponse{}, err
}

package keeper

import (
	"context"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	errorsmod "cosmossdk.io/errors"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) TransferCookbook(goCtx context.Context, msg *types.MsgTransferCookbook) (*types.MsgTransferCookbookResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// check if cookbook is currently owned by creator
	cookbook, found := k.Keeper.GetCookbook(ctx, msg.Id)
	if !found {
		return nil, errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "cookbook not found")
	}

	if cookbook.Creator != msg.Creator {
		return nil, errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "cookbook not owned my message creator")
	}

	cookbook.Creator = msg.Recipient
	creatorAddr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, errorsmod.Wrap(sdkerrors.ErrInvalidAddress, "invalid sender address")
	}
	k.Keeper.UpdateCookbook(ctx, cookbook, creatorAddr)

	err = ctx.EventManager().EmitTypedEvent(&types.EventTransferCookbook{
		Sender:   msg.Creator,
		Receiver: cookbook.Creator,
		Id:       cookbook.Id,
	})

	return &types.MsgTransferCookbookResponse{}, err
}

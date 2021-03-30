package handlers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgUpdateCookbook is used to update cookbook by a developer
func (k msgServer) HandlerMsgUpdateCookbook(ctx context.Context, msg *msgs.MsgUpdateCookbook) (*msgs.MsgUpdateCookbookResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)

	cb, err := k.GetCookbook(sdkCtx, msg.ID)
	if err != nil {
		return nil, errInternal(err)
	}

	// only the original sender (owner) of the cookbook can update the cookbook
	if cb.Sender != msg.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "the owner of the cookbook is different then the current sender")
	}

	cb.Description = msg.Description
	cb.Version = msg.Version
	cb.SupportEmail = msg.SupportEmail
	cb.Developer = msg.Developer

	if err := k.UpdateCookbook(sdkCtx, msg.ID, cb); err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgUpdateCookbookResponse{
		CookbookID: cb.ID,
		Message:    "successfully updated the cookbook",
		Status:     "Success",
	}, nil
}

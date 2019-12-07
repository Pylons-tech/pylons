package handlers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandlerMsgUpdateCookbook is used to update cookbook by a developer
func HandlerMsgUpdateCookbook(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgUpdateCookbook) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	cb, err2 := keeper.GetCookbook(ctx, msg.ID)

	if err2 != nil {
		return errInternal(err2)
	}

	// only the original sender (owner) of the cookbook can update the cookbook
	if !cb.Sender.Equals(msg.Sender) {
		return sdk.ErrUnauthorized("the owner of the cookbook is different then the current sender").Result()
	}

	cb.Description = msg.Description
	cb.Version = msg.Version
	cb.SupportEmail = msg.SupportEmail
	cb.Developer = msg.Developer

	if err := keeper.UpdateCookbook(ctx, msg.ID, cb); err != nil {
		return errInternal(err)
	}

	return sdk.Result{}
}

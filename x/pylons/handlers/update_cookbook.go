package handlers

import (
	"math/rand"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgUpdateCookbook is used to update cookbook by a developer
func HandlerMsgUpdateCookbook(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgUpdateCookbook) (*sdk.Result, error) {
	// set random seed at the start point of handler
	rand.Seed(types.RandomSeed(ctx))
	
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	cb, err2 := keeper.GetCookbook(ctx, msg.ID)

	if err2 != nil {
		return nil, errInternal(err2)
	}

	// only the original sender (owner) of the cookbook can update the cookbook
	if !cb.Sender.Equals(msg.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "the owner of the cookbook is different then the current sender")
	}

	cb.Description = msg.Description
	cb.Version = msg.Version
	cb.SupportEmail = msg.SupportEmail
	cb.Developer = msg.Developer

	if err := keeper.UpdateCookbook(ctx, msg.ID, cb); err != nil {
		return nil, errInternal(err)
	}

	return &sdk.Result{}, nil
}

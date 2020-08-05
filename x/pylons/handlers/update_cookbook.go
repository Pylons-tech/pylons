package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// UpdateCookbookResponse is a struct to control update cookbook response
type UpdateCookbookResponse struct {
	CookbookID string `json:"CookbookID"`
	Message    string
	Status     string
}

// HandlerMsgUpdateCookbook is used to update cookbook by a developer
func HandlerMsgUpdateCookbook(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgUpdateCookbook) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	cb, err := keeper.GetCookbook(ctx, msg.ID)

	if err != nil {
		return nil, errInternal(err)
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

	return marshalJSON(UpdateCookbookResponse{
		CookbookID: cb.ID,
		Message:    "successfully updated the cookbook",
		Status:     "Success",
	})
}

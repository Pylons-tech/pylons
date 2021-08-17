package keeper

import (
	"context"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateCookbook(goCtx context.Context, msg *types.MsgCreateCookbook) (*types.MsgCreateCookbookResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if len(msg.Name) < int(k.MinNameFieldLength(ctx)) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the name of the cookbook should have more than 8 characters")
	}

	if len(msg.Description) < int(k.MinDescriptionFieldLength(ctx)) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	// Check if the value already exists
	_, isFound := k.GetCookbook(ctx, msg.ID)
	if isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("ID %v already set", msg.ID))
	}

	var cookbook = types.Cookbook{
		ID:           msg.ID,
		Creator:      msg.Creator,
		NodeVersion:  types.GetNodeVersionString(),
		Name:         msg.Name,
		Description:  msg.Description,
		Developer:    msg.Developer,
		Version:      msg.Version,
		SupportEmail: msg.SupportEmail,
		CostPerBlock: msg.CostPerBlock,
	}

	k.SetCookbook(
		ctx,
		cookbook,
	)
	return &types.MsgCreateCookbookResponse{}, nil
}

func (k msgServer) UpdateCookbook(goCtx context.Context, msg *types.MsgUpdateCookbook) (*types.MsgUpdateCookbookResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if len(msg.Name) < int(k.MinNameFieldLength(ctx)) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the name of the cookbook should have more than 8 characters")
	}

	if len(msg.Description) < int(k.MinDescriptionFieldLength(ctx)) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	// Check if the value exists
	valFound, isFound := k.GetCookbook(ctx, msg.ID)
	if !isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("ID %v not set", msg.ID))
	}

	// Check if the msg sender is the same as the current owner
	if msg.Creator != valFound.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	var cookbook = types.Cookbook{
		ID:           msg.ID,
		Creator:      msg.Creator,
		NodeVersion:  types.GetNodeVersionString(),
		Name:         msg.Name,
		Description:  msg.Description,
		Developer:    msg.Developer,
		Version:      msg.Version,
		SupportEmail: msg.SupportEmail,
		CostPerBlock: msg.CostPerBlock,
	}

	_, err := valFound.Modified(cookbook)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	k.SetCookbook(ctx, cookbook)

	return &types.MsgUpdateCookbookResponse{}, nil
}

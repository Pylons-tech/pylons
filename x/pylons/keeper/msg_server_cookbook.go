package keeper

import (
	"context"
	"fmt"
	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) CreateCookbook(goCtx context.Context, msg *types.MsgCreateCookbook) (*types.MsgCreateCookbookResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// Check if the value already exists
	_, isFound := k.GetCookbook(ctx, msg.ID)
	if isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("ID %v already set", msg.ID))
	}

	// TODO get config fee from application and perform fee logic
	fee := config.DefaultBasicFee
	if msg.Tier == types.Premium {
		fee = config.DefaultPremiumFee
	}
	_ = fee

	var cookbook = types.Cookbook{
		ID:           msg.ID,
		Creator:      msg.Creator,
		NodeVersion:  "", //TODO add logic for getting configured node version
		Name:         msg.Name,
		Description:  msg.Description,
		Developer:    msg.Developer,
		Version:      msg.Version,
		SupportEmail: msg.SupportEmail,
		Tier:         msg.Tier,
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

	// Check if the value exists
	valFound, isFound := k.GetCookbook(ctx, msg.ID)
	if !isFound {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("ID %v not set", msg.ID))
	}

	// Check if the the msg sender is the same as the current owner
	if msg.Creator != valFound.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	// Check if tier update is legal
	if msg.Tier != valFound.Tier && msg.Tier == types.Basic {
		return nil, sdkerrors.Wrap(types.ErrInvalidTierUpgrade, "cannot downgrade tier on cookbook")
	}

	// TODO if upgrade requested pay fee as PremiumFee - BasicFee
	if msg.Tier != valFound.Tier && msg.Tier == types.Premium{

	}

	var cookbook = types.Cookbook{
		ID:           msg.ID,
		Creator:      msg.Creator,
		NodeVersion:  "", //TODO add logic for getting configured node version
		Name:         msg.Name,
		Description:  msg.Description,
		Developer:    msg.Developer,
		Version:      msg.Version,
		SupportEmail: msg.SupportEmail,
		Tier:         msg.Tier,
		CostPerBlock: msg.CostPerBlock,
	}

	k.SetCookbook(ctx, cookbook)

	return &types.MsgUpdateCookbookResponse{}, nil
}

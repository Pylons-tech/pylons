package handlers

import (
	"context"
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CreateCookbook is used to create cookbook by a developer
func (srv msgServer) CreateCookbook(ctx context.Context, msg *types.MsgCreateCookbook) (*types.MsgCreateCookbookResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	var fee sdk.Coins
	switch msg.Level {
	case types.BasicTier.Level:
		fee = types.BasicTier.Fee
	case types.PremiumTier.Level:
		fee = types.PremiumTier.Fee
	default:
		return nil, errInternal(errors.New("invalid level"))
	}

	if !keeper.HasCoins(srv.Keeper, sdkCtx, sender, fee) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the user doesn't have enough pylons")
	}

	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	if err != nil {
		return nil, errInternal(err)
	}
	err = keeper.SendCoins(srv.Keeper, sdkCtx, sender, pylonsLLCAddress, fee)
	if err != nil {
		return nil, errInternal(err)
	}

	cpb := types.DefaultCostPerBlock
	if msg.CostPerBlock != 0 {
		cpb = msg.CostPerBlock
	}

	cb := types.NewCookbook(msg.SupportEmail, sender, msg.Version, msg.Name, msg.Description, msg.Developer, cpb)

	if msg.CookbookID != "" {
		if srv.HasCookbook(sdkCtx, msg.CookbookID) {
			return nil, errInternal(fmt.Errorf("cookbook with CookbookID %s already exists", msg.CookbookID))
		}
		cb.ID = msg.CookbookID
	}

	if err := srv.SetCookbook(sdkCtx, cb); err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgCreateCookbookResponse{
		CookbookID: cb.ID,
		Message:    "successfully created a cookbook",
		Status:     "Success",
	}, nil
}

// HandlerMsgUpdateCookbook is used to update cookbook by a developer
func (srv msgServer) HandlerMsgUpdateCookbook(ctx context.Context, msg *types.MsgUpdateCookbook) (*types.MsgUpdateCookbookResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)

	cb, err := srv.GetCookbook(sdkCtx, msg.ID)
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

	if err := srv.UpdateCookbook(sdkCtx, msg.ID, cb); err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgUpdateCookbookResponse{
		CookbookID: cb.ID,
		Message:    "successfully updated the cookbook",
		Status:     "Success",
	}, nil
}

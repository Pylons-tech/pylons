package handlers

import (
	"context"
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgCreateCookbook is used to create cookbook by a developer
func (k msgServer) HandlerMsgCreateCookbook(ctx context.Context, msg *msgs.MsgCreateCookbook) (*msgs.MsgCreateCookbookResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	var fee sdk.Coins
	if *msg.Level == types.BasicTier.Level {
		fee = types.BasicTier.Fee
	} else if *msg.Level == types.PremiumTier.Level {
		fee = types.PremiumTier.Fee
	} else {
		return nil, errInternal(errors.New("invalid level"))
	}

	if !keep.HasCoins(k.Keeper, sdkCtx, sender, fee) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the user doesn't have enough pylons")
	}

	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	if err != nil {
		return nil, errInternal(err)
	}
	err = keep.SendCoins(k.Keeper, sdkCtx, sender, pylonsLLCAddress, fee)
	if err != nil {
		return nil, errInternal(err)
	}

	cpb := msgs.DefaultCostPerBlock
	if msg.CostPerBlock != 0 {
		cpb = int(msg.CostPerBlock)
	}

	cb := types.NewCookbook(*msg.SupportEmail, sender, *msg.Version, msg.Name, msg.Description, msg.Developer, cpb)

	if msg.CookbookID != "" {
		if k.HasCookbook(sdkCtx, msg.CookbookID) {
			return nil, errInternal(fmt.Errorf("A cookbook with CookbookID %s already exists", msg.CookbookID))
		}
		cb.ID = msg.CookbookID
	}

	if err := k.SetCookbook(sdkCtx, cb); err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgCreateCookbookResponse{
		CookbookID: cb.ID,
		Message:    "successfully created a cookbook",
		Status:     "Success",
	}, nil
}

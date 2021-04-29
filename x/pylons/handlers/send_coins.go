package handlers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// SendCoins is used to transact pylons between people
func (k msgServer) SendCoins(ctx context.Context, msg *types.MsgSendCoins) (*types.MsgSendCoinsResponse, error) {
	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)
	receiver, _ := sdk.AccAddressFromBech32(msg.Receiver)

	if !keeper.HasCoins(k.Keeper, sdkCtx, sender, msg.Amount) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Sender does not have enough coins")
	}

	err = keeper.SendCoins(k.Keeper, sdkCtx, sender, receiver, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgSendCoinsResponse{}, nil
}

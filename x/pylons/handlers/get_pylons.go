package handlers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgGetPylons is used to send pylons to requesters. This handler is part of the faucet
func (k msgServer) HandlerMsgGetPylons(ctx context.Context, msg *msgs.MsgGetPylons) (*msgs.MsgGetPylonsResponse, error) {
	sdkCtx := sdk.UnwrapSDKContext(ctx)
	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}
	// TODO: filter pylons out of all the coins
	requester, _ := sdk.AccAddressFromBech32(msg.Requester)
	err = k.CoinKeeper.AddCoins(sdkCtx, requester, msg.Amount) // If so, deduct the Bid amount from the sender
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Buyer does not have enough coins")
	}

	return &msgs.MsgGetPylonsResponse{
		Message: "successfully got the pylons",
		Status:  "Success",
	}, nil
}

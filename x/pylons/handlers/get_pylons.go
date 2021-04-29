package handlers

import (
	"context"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// GetPylons is used to send pylons to requesters. This handler is part of the faucet
func (k msgServer) GetPylons(ctx context.Context, msg *types.MsgGetPylons) (*types.MsgGetPylonsResponse, error) {
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

	return &types.MsgGetPylonsResponse{
		Message: "successfully got the pylons",
		Status:  "Success",
	}, nil
}

// GoogleIAPGetPylons is used to send pylons to requesters after google iap verification
func (k msgServer) GoogleIAPGetPylons(ctx context.Context, msg *types.MsgGoogleIAPGetPylons) (*types.MsgGoogleIAPGetPylonsResponse, error) {
	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	requester, _ := sdk.AccAddressFromBech32(msg.Requester)
	// Validate if purchase token does exist within the list already
	if k.HasGoogleIAPOrder(sdkCtx, msg.PurchaseToken) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the iap order ID is already being used")
	}

	// Register purchase token before giving coins
	iap := types.NewGoogleIAPOrder(
		msg.ProductID,
		msg.PurchaseToken,
		msg.ReceiptDataBase64,
		msg.Signature,
		requester,
	)

	err = k.RegisterGoogleIAPOrder(sdkCtx, iap)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("error registering iap order: %s", err.Error()))
	}

	// Add coins based on the package
	err = k.CoinKeeper.AddCoins(sdkCtx, requester, iap.GetAmount())
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.MsgGoogleIAPGetPylonsResponse{
		Message: "successfully got the pylons",
		Status:  "Success",
	}, nil
}

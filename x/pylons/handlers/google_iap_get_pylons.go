package handlers

import (
	"context"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgGoogleIAPGetPylons is used to send pylons to requesters after google iap verification
func (k msgServer) HandlerMsgGoogleIAPGetPylons(ctx context.Context, msg *msgs.MsgGoogleIAPGetPylons) (*msgs.MsgGoogleIAPGetPylonsResponse, error) {
	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	requester := sdk.AccAddress(msg.Requester)
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

	return &msgs.MsgGoogleIAPGetPylonsResponse{
		Message: "successfully got the pylons",
		Status:  "Success",
	}, nil
}

package handlers

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// GetPylonsResponse is the response for get-pylons
type GetPylonsResponse struct {
	Message string
	Status  string
}

// HandlerMsgGetPylons is used to send pylons to requesters. This handler is part of the
// faucet
func HandlerMsgGetPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgGetPylons) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	// Validate if purchase token does exist within the list already
	if keeper.HasGoogleIAPOrder(ctx, msg.OrderID) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the iap order ID is already being used")
	}

	// Register purchase token before giving coins
	iap := types.NewGoogleIAPOrder(
		msg.OrderID,
		msg.PackageName,
		msg.ProductID,
		msg.PurchaseTime,
		msg.PurchaseState,
		msg.PurchaseToken,
		msg.Signature,
		msg.Requester,
	)
	err = keeper.RegisterGoogleIAPOrder(ctx, iap)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("error registering iap order: %s", err.Error()))
	}

	// Add coins based on the package
	_, err = keeper.CoinKeeper.AddCoins(ctx, msg.Requester, iap.GetAmount())
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return marshalJSON(GetPylonsResponse{
		Message: "successfully got the pylons",
		Status:  "Success",
	})
}

package handlers

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// GoogleIAPGetPylonsResponse is the response for get-pylons
type GoogleIAPGetPylonsResponse struct {
	Message string
	Status  string
}

// HandlerMsgGoogleIAPGetPylons is used to send pylons to requesters after google iap verification
func HandlerMsgGoogleIAPGetPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgGoogleIAPGetPylons) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	// Validate if purchase token does exist within the list already
	if keeper.HasGoogleIAPOrder(ctx, msg.PurchaseToken) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the iap order ID is already being used")
	}

	// Register purchase token before giving coins
	iap := types.NewGoogleIAPOrder(
		msg.ProductID,
		msg.PurchaseToken,
		msg.ReceiptData,
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

	return marshalJSON(GoogleIAPGetPylonsResponse{
		Message: "successfully got the pylons",
		Status:  "Success",
	})
}

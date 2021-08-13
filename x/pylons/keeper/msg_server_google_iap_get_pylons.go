package keeper

import (
	"context"
	"github.com/Workiva/go-datastructures/threadsafe/err"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k msgServer) GoogleIAPGetPylons(goCtx context.Context, msg *types.MsgGoogleIAPGetPylons) (*types.MsgGoogleIAPGetPylonsResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if k.HasGoogleIAPOrder(ctx, msg.PurchaseToken) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the iap order ID is already being used")
	}


iap := types.GoogleIAPOrder{
	Creator:           msg.Creator,
	ProductID:         msg.ProductID,
	PurchaseToken:     msg.PurchaseToken,
	ReceiptDataBase64: msg.ReceiptDataBase64,
	Signature:         msg.Signature,
}

	k.SetGoogleIAPOrder(ctx, iap)

	// if address is invalid, it will already fail before the message handling gets here
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)

	// Add coins based on the package
	err = k.bankKeeper.AddCoins(ctx, addr, iap.GetAmount())
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.MsgGoogleIAPGetPylonsResponse{}, nil
}

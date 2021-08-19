package keeper

import (
	"context"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) GoogleInAppPurchaseGetPylons(goCtx context.Context, msg *types.MsgGoogleInAppPurchaseGetPylons) (*types.MsgGoogleInAppPurchaseGetPylonsResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if k.HasGoogleIAPOrder(ctx, msg.PurchaseToken) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the iap order ID is already being used")
	}

	if err := k.ValidateGoogleIAPSignature(ctx, msg); err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrorInvalidSigner, "Google IAP Signature is invalid")
	}

	iap := types.GoogleInAppPurchaseOrder{
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
	err := k.bankKeeper.AddCoins(ctx, addr, k.GetAmount(ctx, iap))
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.MsgGoogleInAppPurchaseGetPylonsResponse{}, nil
}

package keeper

import (
	"context"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) GoogleInAppPurchaseGetCoins(goCtx context.Context, msg *types.MsgGoogleInAppPurchaseGetCoins) (*types.MsgGoogleInAppPurchaseGetCoinsResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if k.HasGoogleIAPOrder(ctx, msg.PurchaseToken) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the Google IAP order ID is already being used")
	}

	// find matching package from list of coin issuers
	var coinIssuer types.CoinIssuer
	var googleIapPackage types.GoogleInAppPurchasePackage
CoinIssuersLoop:
	for _, ci := range types.DefaultCoinIssuers {
		for _, p := range ci.Packages {
			if p.ProductID == msg.ProductID {
				coinIssuer = ci
				googleIapPackage = p
				break CoinIssuersLoop
			}
		}
	}

	if err := types.ValidateGoogleIAPSignature(msg, coinIssuer); err != nil {
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

	amt := sdk.NewCoins(sdk.NewCoin(coinIssuer.CoinDenom, googleIapPackage.Amount))
	err := k.MintCoinsToAddr(ctx, addr, amt)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventGooglePurchase{
		Creator:           iap.Creator,
		ProductID:         iap.ProductID,
		PurchaseToken:     iap.PurchaseToken,
		ReceiptDataBase64: iap.ReceiptDataBase64,
		Signature:         iap.Signature,
	})

	return &types.MsgGoogleInAppPurchaseGetCoinsResponse{}, err
}

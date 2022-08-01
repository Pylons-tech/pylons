package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k msgServer) GoogleInAppPurchaseGetCoins(goCtx context.Context, msg *v1beta1.MsgGoogleInAppPurchaseGetCoins) (*v1beta1.MsgGoogleInAppPurchaseGetCoinsResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if k.HasGoogleIAPOrder(ctx, msg.PurchaseToken) {
		return nil, sdkerrors.Wrap(v1beta1.ErrReceiptAlreadyUsed, "the Google IAP order ID is already being used")
	}

	// find matching package from list of coin issuers
	var coinIssuer v1beta1.CoinIssuer
	var googleIapPackage v1beta1.GoogleInAppPurchasePackage
CoinIssuersLoop:
	for _, ci := range v1beta1.DefaultCoinIssuers {
		for _, p := range ci.Packages {
			if p.ProductId == msg.ProductId {
				coinIssuer = ci
				googleIapPackage = p
				break CoinIssuersLoop
			}
		}
	}
	if len(coinIssuer.CoinDenom) == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid product id")
	}

	if err := v1beta1.ValidateGoogleIAPSignature(msg, coinIssuer); err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrorInvalidSigner, "Google IAP Signature is invalid")
	}

	iap := v1beta1.GoogleInAppPurchaseOrder{
		Creator:           msg.Creator,
		ProductId:         msg.ProductId,
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

	err = ctx.EventManager().EmitTypedEvent(&v1beta1.EventGooglePurchase{
		Creator:           iap.Creator,
		ProductId:         iap.ProductId,
		PurchaseToken:     iap.PurchaseToken,
		ReceiptDataBase64: iap.ReceiptDataBase64,
		Signature:         iap.Signature,
	})

	return &v1beta1.MsgGoogleInAppPurchaseGetCoinsResponse{}, err
}

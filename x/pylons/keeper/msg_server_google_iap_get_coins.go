package keeper

import (
	"context"
	"crypto"
	"crypto/rsa"
	"crypto/sha1"
	"crypto/x509"
	"encoding/base64"
	"fmt"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// ValidateGoogleIAPSignature is function for testing signature on local
func ValidateGoogleIAPSignature(msg *types.MsgGoogleInAppPurchaseGetCoins, coinIssuer types.CoinIssuer) error {
	// References
	// offline verification JS module https://github.com/voltrue2/in-app-purchase/blob/e966ee1348bd4f67581779abeec59c4bbc2b2ebc/lib/google.js#L788
	// Cordova Plugin code that check offline https://github.com/j3k0/cordova-plugin-purchase/blob/8861bd2392a48d643ffc754b8f59afc1e6afab60/src/android/cc/fovea/Security.java#L94
	// https://stackoverflow.com/questions/31349710/google-play-billing-response-signature-verification

	playStorePubKeyBytes, err := base64.StdEncoding.DecodeString(coinIssuer.GoogleInAppPurchasePubKey)
	if err != nil {
		return fmt.Errorf("play store base64 public key decoding failure: %s", err.Error())
	}
	re, err := x509.ParsePKIXPublicKey(playStorePubKeyBytes)
	if err != nil {
		return err
	}
	pub := re.(*rsa.PublicKey)
	receiptData, err := base64.StdEncoding.DecodeString(msg.ReceiptDataBase64)
	if err != nil {
		return err
	}

	// Google forces us to use unsafe sha1 for IAP verification
	h := sha1.New() // nolint: gosec
	_, err = h.Write(receiptData)
	if err != nil {
		return err
	}
	digest := h.Sum(nil)

	ds, err := base64.StdEncoding.DecodeString(msg.Signature)
	if err != nil {
		return fmt.Errorf("msg signature base64 decoding failure: %s", err.Error())
	}
	err = rsa.VerifyPKCS1v15(pub, crypto.SHA1, digest, ds)
	return err
}

func (k msgServer) GoogleInAppPurchaseGetCoins(goCtx context.Context, msg *types.MsgGoogleInAppPurchaseGetCoins) (*types.MsgGoogleInAppPurchaseGetCoinsResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if k.HasGoogleIAPOrder(ctx, msg.PurchaseToken) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the Google IAP order ID is already being used")
	}

	// find matching package from list of coin issuers
	var coinIssuer types.CoinIssuer
	var googleIapPackage types.GoogleInAppPurchasePackage
	CoinIssuersLoop: for _, ci := range k.CoinIssuers(ctx){
		for _, p := range ci.Packages {
			if p.ProductID == msg.ProductID {
				coinIssuer = ci
				googleIapPackage = p
				break CoinIssuersLoop
			}
		}
	}

	if err := ValidateGoogleIAPSignature(msg, coinIssuer); err != nil {
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
	err := k.bankKeeper.MintCoins(ctx, types.CoinsIssuerName, amt)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	err = k.bankKeeper.SendCoinsFromModuleToAccount(ctx, types.CoinsIssuerName, addr, amt)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.MsgGoogleInAppPurchaseGetCoinsResponse{}, nil
}

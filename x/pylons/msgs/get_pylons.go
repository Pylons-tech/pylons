package msgs

import (
	// "context"
	"encoding/json"
	"fmt"
	"strings"

	// "io/ioutil"

	// "github.com/awa/go-iap/playstore"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgGetPylons defines a GetPylons message
type MsgGetPylons struct {
	// TODO: add google playstore purchase data; need to discuss what to put here
	// {
	// 	"orderId": "your.order.id",
	// 	"packageName": "your.package.name",
	// 	"productId": "your.product.id",
	// 	"purchaseTime": 1526476218113,
	// 	"purchaseState": 0,
	// 	"purchaseToken": "your.purchase.token"
	// }
	PurchaseToken string // TODO: for now, token with prefix "TrueToken" is correct
	Amount        sdk.Coins
	Requester     sdk.AccAddress
}

// NewMsgGetPylons is a function to get MsgGetPylons msg from required params
func NewMsgGetPylons(amount sdk.Coins, requester sdk.AccAddress) MsgGetPylons {
	return MsgGetPylons{
		PurchaseToken: "TrueToken8X7325",
		Amount:        amount,
		Requester:     requester,
	}
}

// Route should return the name of the module
func (msg MsgGetPylons) Route() string { return RouterKey }

// Type should return the action
func (msg MsgGetPylons) Type() string { return "get_pylons" }

// ValidateBasic is a function to validate MsgGetPylons msg
func (msg MsgGetPylons) ValidateBasic() error {

	if msg.Requester.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Requester.String())
	}
	if !msg.Amount.IsAllPositive() {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "Amount cannot be less than 0/negative")
	}

	// offline testMode checking JS module https://github.com/voltrue2/in-app-purchase/blob/e966ee1348bd4f67581779abeec59c4bbc2b2ebc/lib/google.js#L788

	// // You need to prepare a public key for your Android app's in app billing
	// // at https://console.developers.google.com.
	// playStorePubKey, err := ioutil.ReadFile("jsonKey.json")
	// if err != nil {
	// 	return err
	// }

	// playStoreClient, err := playstore.New(playStorePubKey)
	// if err != nil {
	// 	return err
	// }
	// playStoreCtx := context.Background()

	// playStoreResp, err := playStoreClient.VerifySubscription(playStoreCtx, "package", "subscriptionID", "purchaseToken")
	// // 	urls := googleapi.ResolveRelative(c.s.BasePath, "{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}")

	// // TODO: VerifySubscription method is still using the http endpoint.
	// // urls := googleapi.ResolveRelative(c.s.BasePath, "{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:refund")

	// https://stackoverflow.com/questions/31349710/google-play-billing-response-signature-verification

	// {
	// 	"orderId": "your.order.id",
	// 	"packageName": "your.package.name",
	// 	"productId": "your.product.id",
	// 	"purchaseTime": 1526476218113,
	// 	"purchaseState": 0,
	// 	"purchaseToken": "your.purchase.token"
	// }
	// Another potential problem is that purchase only has productId
	// and when we add one more package, should register by updating code
	// want to discuss about this.
	// suggestion: Pylons LLC validator can register a package by running a createPackage msg

	// Cordova Plugin code that check offline
	// https://github.com/j3k0/cordova-plugin-purchase/blob/8861bd2392a48d643ffc754b8f59afc1e6afab60/src/android/cc/fovea/Security.java#L94

	// We should research are ask google for offline verification from public key and if it's possible
	// The best way is to contact google team and test with real tokens

	// fmt.Println("Handling playstore response", playStoreResp)
	// return err
	if !strings.HasPrefix(msg.PurchaseToken, "TrueToken") {
		return fmt.Errorf("wrong purchase token %s", msg.PurchaseToken)
	}
	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgGetPylons) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners encodes the message for signing
func (msg MsgGetPylons) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Requester}
}

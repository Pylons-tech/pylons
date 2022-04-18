package types

import (

	// Google forces us to use unsafe sha1 for IAP verification
	"encoding/base64"
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgGoogleInAppPurchaseGetCoins{}

func NewMsgGoogleIAPGetCoins(creator string, productID string, purchaseToken string, receiptDataBase64 string, signature string) *MsgGoogleInAppPurchaseGetCoins {
	return &MsgGoogleInAppPurchaseGetCoins{
		Creator:           creator,
		ProductID:         productID,
		PurchaseToken:     purchaseToken,
		ReceiptDataBase64: receiptDataBase64,
		Signature:         signature,
	}
}

func (msg *MsgGoogleInAppPurchaseGetCoins) Route() string {
	return RouterKey
}

func (msg *MsgGoogleInAppPurchaseGetCoins) Type() string {
	return "GoogleIAPGetCoins"
}

func (msg *MsgGoogleInAppPurchaseGetCoins) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgGoogleInAppPurchaseGetCoins) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgGoogleInAppPurchaseGetCoins) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid address (%s)", err)
	}

	var jsonData map[string]interface{}

	receiptData, err := base64.StdEncoding.DecodeString(msg.ReceiptDataBase64)
	if err != nil {
		return err
	}

	err = json.Unmarshal(receiptData, &jsonData)
	if err != nil {
		return err
	}

	if msg.PurchaseToken != jsonData["purchaseToken"] {
		return sdkerrors.Wrapf(ErrPurchaseTokenMisMatch, "purchaseToken %s doesn't match with receipt data", msg.PurchaseToken)
	}
	if msg.ProductID != jsonData["productId"] {
		return sdkerrors.Wrapf(ErrProductIDMisMatch, "productId %s doesn't match with receipt data", msg.ProductID)
	}
	return nil
}

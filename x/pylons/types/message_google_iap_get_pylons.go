package types

import (

	// Google forces us to use unsafe sha1 for IAP verification
	"encoding/base64"
	"encoding/json"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgGoogleIAPGetPylons{}

func NewMsgGoogleIAPGetPylons(creator string, productID string, purchaseToken string, receiptDataBase64 string, signature string) *MsgGoogleIAPGetPylons {
	return &MsgGoogleIAPGetPylons{
		Creator:           creator,
		ProductID:         productID,
		PurchaseToken:     purchaseToken,
		ReceiptDataBase64: receiptDataBase64,
		Signature:         signature,
	}
}

func (msg *MsgGoogleIAPGetPylons) Route() string {
	return RouterKey
}

func (msg *MsgGoogleIAPGetPylons) Type() string {
	return "GoogleIAPGetPylons"
}

func (msg *MsgGoogleIAPGetPylons) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgGoogleIAPGetPylons) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgGoogleIAPGetPylons) ValidateBasic() error {
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
		return fmt.Errorf("purchaseToken does not match with receipt data")
	}
	if msg.ProductID != jsonData["productId"] {
		return fmt.Errorf("productId does not match with receipt data")
	}
	return nil
}

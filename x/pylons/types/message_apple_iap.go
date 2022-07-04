package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

const TypeMsgAppleIap = "apple_iap"

var _ sdk.Msg = &MsgAppleIap{}

func NewMsgAppleIap(creator string, productID string, purchaseID string, receiptDataBase64 string) *MsgAppleIap {
	return &MsgAppleIap{
		Creator:           creator,
		ProductId:         productID,
		PurchaseId:        purchaseID,
		ReceiptDataBase64: receiptDataBase64,
	}
}

func (msg *MsgAppleIap) Route() string {
	return RouterKey
}

func (msg *MsgAppleIap) Type() string {
	return TypeMsgAppleIap
}

func (msg *MsgAppleIap) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgAppleIap) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgAppleIap) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	return nil
}

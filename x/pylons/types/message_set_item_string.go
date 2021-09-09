package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgSetItemString{}

func NewMsgSetItemString(creator string, cookbookID string, id string, field string, value string) *MsgSetItemString {
	return &MsgSetItemString{
		Creator:    creator,
		CookbookID: cookbookID,
		ID:         id,
		Field:      field,
		Value:      value,
	}
}

func (msg *MsgSetItemString) Route() string {
	return RouterKey
}

func (msg *MsgSetItemString) Type() string {
	return "SetItemString"
}

func (msg *MsgSetItemString) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgSetItemString) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgSetItemString) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	if err = ValidateID(msg.CookbookID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	if err = ValidateNumber(msg.ID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	if err = ValidateID(msg.Field); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	// do not validate Value field as user can set to whatever they want

	return nil
}

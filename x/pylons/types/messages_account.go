package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var (
	_ sdk.Msg = &MsgCreateAccount{}
	_ sdk.Msg = &MsgUpdateAccount{}
)

func NewMsgCreateAccount(creator string, username string, token string, noAppCheck bool) *MsgCreateAccount {
	return &MsgCreateAccount{
		Creator:    creator,
		Username:   username,
		Token:      token,
		NoAppCheck: noAppCheck,
	}
}

func (msg *MsgCreateAccount) Route() string {
	return RouterKey
}

func (msg *MsgCreateAccount) Type() string {
	return "CreateAccount"
}

func (msg *MsgCreateAccount) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgCreateAccount) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgCreateAccount) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address: %s", err)
	}

	if err = ValidateUsername(msg.Username); err != nil {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	return nil
}

func NewMsgUpdateAccount(creator string, username string) *MsgUpdateAccount {
	return &MsgUpdateAccount{
		Creator:  creator,
		Username: username,
	}
}

func (msg *MsgUpdateAccount) Route() string {
	return RouterKey
}

func (msg *MsgUpdateAccount) Type() string {
	return "UpdateAccount"
}

func (msg *MsgUpdateAccount) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgUpdateAccount) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgUpdateAccount) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if err = ValidateUsername(msg.Username); err != nil {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	return nil
}

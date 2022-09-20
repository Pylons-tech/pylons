package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgRegisterKYCAddress{}

func NewMsgRegisterKYCAddress(accountAddr, username, provider, providerID string, level uint64) *MsgRegisterKYCAddress {
	return &MsgRegisterKYCAddress{
		AccountAddr: accountAddr,
		Username:    username,
		Level:       level,
		Provider:    provider,
		ProviderId:  providerID,
	}
}

func (msg *MsgRegisterKYCAddress) Route() string {
	return RouterKey
}

func (msg *MsgRegisterKYCAddress) Type() string {
	return "SendItems"
}

func (msg *MsgRegisterKYCAddress) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.AccountAddr)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgRegisterKYCAddress) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgRegisterKYCAddress) ValidateBasic() error {
	// Validate Sender and receiver addresses
	_, err := sdk.AccAddressFromBech32(msg.AccountAddr)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if err = ValidateUsername(msg.Username); err != nil {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	if err = ValidateUsername(msg.Provider); err != nil {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	return nil
}

func NewMsgRemoveKYCAddress(accountAddr, username, provider, providerID string, level uint64) *MsgRemoveKYCAddress {
	return &MsgRemoveKYCAddress{
		AccountAddr: accountAddr,
		Username:    username,
		Level:       level,
		Provider:    provider,
		ProviderId:  providerID,
	}
}

func (msg *MsgRemoveKYCAddress) Route() string {
	return RouterKey
}

func (msg *MsgRemoveKYCAddress) Type() string {
	return "SendItems"
}

func (msg *MsgRemoveKYCAddress) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.AccountAddr)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgRemoveKYCAddress) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgRemoveKYCAddress) ValidateBasic() error {
	// Validate Sender and receiver addresses
	_, err := sdk.AccAddressFromBech32(msg.AccountAddr)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if err = ValidateUsername(msg.Username); err != nil {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	if err = ValidateUsername(msg.Provider); err != nil {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	return nil
}

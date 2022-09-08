package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgRegisterKYCAddress{}

func NewsgRegisterKYCAddress(creator string, username string) *MsgRegisterKYCAddress {
	return &MsgRegisterKYCAddress{
		Creator:  creator,
		Username: username,
	}
}

func (msg *MsgRegisterKYCAddress) Route() string {
	return RouterKey
}

func (msg *MsgRegisterKYCAddress) Type() string {
	return "SendItems"
}

func (msg *MsgRegisterKYCAddress) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
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
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if err = ValidateUsername(msg.Username); err != nil {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}
	return nil
}

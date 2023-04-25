package types

import (
	errorsmod "cosmossdk.io/errors"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var (
	_ sdk.Msg = &MsgCreateAccount{}
	_ sdk.Msg = &MsgUpdateAccount{}
	_ sdk.Msg = &MsgSetUsername{}
)

func NewMsgCreateAccount(creator, token, referral string) *MsgCreateAccount {
	return &MsgCreateAccount{
		Creator:         creator,
		Token:           token,
		ReferralAddress: referral,
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
		return errorsmod.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address: %s", err)
	}

	return nil
}

func NewMsgUpdateAccount(creator, username string) *MsgUpdateAccount {
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
		return errorsmod.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if err = ValidateUsername(msg.Username); err != nil {
		return errorsmod.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	return nil
}

func NewMsgSetUsername(creator, username string) *MsgSetUsername {
	return &MsgSetUsername{
		Creator:  creator,
		Username: username,
	}
}

func (msg *MsgSetUsername) Route() string {
	return RouterKey
}

func (msg *MsgSetUsername) Type() string {
	return "SetUsername"
}

func (msg *MsgSetUsername) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgSetUsername) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgSetUsername) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return errorsmod.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address: %s", err)
	}
	if err = ValidateUsername(msg.Username); err != nil {
		return errorsmod.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	return nil
}

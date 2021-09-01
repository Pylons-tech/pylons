package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateAccount{}

func NewMsgCreateAccount(creator string, username string) *MsgCreateAccount {
	return &MsgCreateAccount{
		Creator: creator,
		Value:   username,
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

	if err = ValidateID(msg.Value); err != nil {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid username field: %s", err)
	}

	return nil
}

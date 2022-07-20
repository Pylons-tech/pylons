package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateCookbook{}

func NewMsgCreateCookbook(creator string, id string, name string, description string, developer string, version string, supportEmail string, enabled bool) *MsgCreateCookbook {
	return &MsgCreateCookbook{
		Creator:      creator,
		Id:           id,
		Name:         name,
		Description:  description,
		Developer:    developer,
		Version:      version,
		SupportEmail: supportEmail,
		Enabled:      enabled,
	}
}

func (msg *MsgCreateCookbook) Route() string {
	return RouterKey
}

func (msg *MsgCreateCookbook) Type() string {
	return "CreateCookbook"
}

func (msg *MsgCreateCookbook) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgCreateCookbook) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgCreateCookbook) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if !ValidatedDenom(msg.Id) {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid cookbook denom can only contain a-z A-Z 0-9 '-' and '_'")
	}

	// check length of the name and description fields
	if err = ValidateFieldLength(msg.Name, DefaultMinFieldLength, DefaultMaxFieldLength); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateFieldLength(msg.Description, DefaultMinFieldLength, DefaultMaxFieldLength); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateID(msg.Id); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateEmail(msg.SupportEmail); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	return nil
}

var _ sdk.Msg = &MsgUpdateCookbook{}

func NewMsgUpdateCookbook(creator string, id string, name string, description string, developer string, version string, supportEmail string, enabled bool) *MsgUpdateCookbook {
	return &MsgUpdateCookbook{
		Creator:      creator,
		Id:           id,
		Name:         name,
		Description:  description,
		Developer:    developer,
		Version:      version,
		SupportEmail: supportEmail,
		Enabled:      enabled,
	}
}

func (msg *MsgUpdateCookbook) Route() string {
	return RouterKey
}

func (msg *MsgUpdateCookbook) Type() string {
	return "UpdateCookbook"
}

func (msg *MsgUpdateCookbook) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgUpdateCookbook) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgUpdateCookbook) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if !ValidatedDenom(msg.Id) {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid cookbook denom can only contain a-z A-Z 0-9 '-' and '_'")
	}

	// check length of the name and description fields
	if err = ValidateFieldLength(msg.Name, DefaultMinFieldLength, DefaultMaxFieldLength); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateFieldLength(msg.Description, DefaultMinFieldLength, DefaultMaxFieldLength); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateID(msg.Id); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateEmail(msg.SupportEmail); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return nil
}

package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateCookbook{}

func NewMsgCreateCookbook(creator string, id string, name string, description string, developer string, version string, supportEmail string, tier int64, costPerBlock uint64, enabled bool) *MsgCreateCookbook {
	return &MsgCreateCookbook{
		Creator:      creator,
		ID:           id,
		Name:         name,
		Description:  description,
		Developer:    developer,
		Version:      version,
		SupportEmail: supportEmail,
		Tier:         tier,
		CostPerBlock: costPerBlock,
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

	if err = ValidateID(msg.ID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if len(msg.Name) < 8 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the name of the cookbook should have more than 8 characters")
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	if err = ValidateEmail(msg.SupportEmail); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateTier(msg.Tier); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return nil
}

var _ sdk.Msg = &MsgUpdateCookbook{}

func NewMsgUpdateCookbook(creator string, id string, name string, description string, developer string, version string, supportEmail string, tier int64, costPerBlock uint64, enabled bool) *MsgUpdateCookbook {
	return &MsgUpdateCookbook{
		Creator:      creator,
		ID:           id,
		Name:         name,
		Description:  description,
		Developer:    developer,
		Version:      version,
		SupportEmail: supportEmail,
		Tier:         tier,
		CostPerBlock: costPerBlock,
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

	if err = ValidateID(msg.ID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if len(msg.Name) < 8 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the name of the cookbook should have more than 8 characters")
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	if err = ValidateEmail(msg.SupportEmail); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateTier(msg.Tier); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return nil
}

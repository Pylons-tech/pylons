package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateCookbook{}

func NewMsgCreateCookbook(creator string, index string, nodeVersion string, name string, description string, developer string, version string, supportEmail string, level int64, costPerBlock uint64) *MsgCreateCookbook {
	return &MsgCreateCookbook{
		Creator:      creator,
		Index:        index,
		NodeVersion:  nodeVersion,
		Name:         name,
		Description:  description,
		Developer:    developer,
		Version:      version,
		SupportEmail: supportEmail,
		Level:        level,
		CostPerBlock: costPerBlock,
		Enabled: true, // Cookbook is enabled by default at creation
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
	return nil
}

var _ sdk.Msg = &MsgUpdateCookbook{}

func NewMsgUpdateCookbook(creator string, index string, nodeVersion string, name string, description string, developer string, version string, supportEmail string, level int64, costPerBlock uint64, enabled bool) *MsgUpdateCookbook {
	return &MsgUpdateCookbook{
		Creator:      creator,
		Index:        index,
		NodeVersion:  nodeVersion,
		Name:         name,
		Description:  description,
		Developer:    developer,
		Version:      version,
		SupportEmail: supportEmail,
		Level:        level,
		CostPerBlock: costPerBlock,
		Enabled: enabled,
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
	return nil
}

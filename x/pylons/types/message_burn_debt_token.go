package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgBurnDebtToken{}

func NewMsgBurnDebtToken(creator string, redeemInfo RedeemInfo) *MsgBurnDebtToken {
	return &MsgBurnDebtToken{
		Creator:    creator,
		RedeemInfo: redeemInfo,
	}
}

func (msg *MsgBurnDebtToken) Route() string {
	return RouterKey
}

func (msg *MsgBurnDebtToken) Type() string {
	return "BurnDebtToken"
}

func (msg *MsgBurnDebtToken) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgBurnDebtToken) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgBurnDebtToken) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	err = ValidateRedeemInfo(msg.RedeemInfo)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, err.Error())
	}
	return nil
}

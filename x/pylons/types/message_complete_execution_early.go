package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCompleteExecutionEarly{}

func NewMsgCompleteExecutionEarly(creator string, id string) *MsgCompleteExecutionEarly {
	return &MsgCompleteExecutionEarly{
		Creator: creator,
		ID:      id,
	}
}

func (msg *MsgCompleteExecutionEarly) Route() string {
	return RouterKey
}

func (msg *MsgCompleteExecutionEarly) Type() string {
	return "CompleteExecutionEarly"
}

func (msg *MsgCompleteExecutionEarly) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgCompleteExecutionEarly) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgCompleteExecutionEarly) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	return nil
}

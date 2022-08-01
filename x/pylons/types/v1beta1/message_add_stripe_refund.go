package v1beta1

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

const TypeMsgAddStripeRefund = "add_stripe_refund"

var _ sdk.Msg = &MsgAddStripeRefund{}

func NewMsgAddStripeRefund(creator string, payment *PaymentInfo) *MsgAddStripeRefund {
	return &MsgAddStripeRefund{
		Creator: creator,
		Payment: payment,
	}
}

func (msg *MsgAddStripeRefund) Route() string {
	return RouterKey
}

func (msg *MsgAddStripeRefund) Type() string {
	return TypeMsgAddStripeRefund
}

func (msg *MsgAddStripeRefund) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgAddStripeRefund) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgAddStripeRefund) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	if err = ValidatePaymentInfo(*msg.Payment); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	return nil
}

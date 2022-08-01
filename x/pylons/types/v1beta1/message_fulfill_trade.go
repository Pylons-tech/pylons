package v1beta1

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgFulfillTrade{}

func NewMsgFulfillTrade(creator string, id, coinInputsIndex uint64, items []ItemRef, paymentInfos []PaymentInfo) *MsgFulfillTrade {
	return &MsgFulfillTrade{
		Creator:         creator,
		Id:              id,
		CoinInputsIndex: coinInputsIndex,
		Items:           items,
		PaymentInfos:    paymentInfos,
	}
}

func (msg *MsgFulfillTrade) Route() string {
	return RouterKey
}

func (msg *MsgFulfillTrade) Type() string {
	return "FulfillTrade"
}

func (msg *MsgFulfillTrade) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgFulfillTrade) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgFulfillTrade) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	for _, item := range msg.Items {
		err = ValidateItemID(item.ItemId)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		err = ValidateID(item.CookbookId)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	for _, pi := range msg.PaymentInfos {
		if err = ValidatePaymentInfo(pi); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	return nil
}

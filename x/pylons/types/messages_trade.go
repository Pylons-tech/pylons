package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateTrade{}

func NewMsgCreateTrade(creator string, coinInput sdk.Coin, itemInputs []ItemInput, coinOutput sdk.Coin, itemOutputs []ItemRef, extraInfo string) *MsgCreateTrade {
	return &MsgCreateTrade{
		Creator:     creator,
		CoinInput:   coinInput,
		ItemInputs:  itemInputs,
		CoinOutput:  coinOutput,
		ItemOutputs: itemOutputs,
		ExtraInfo:   extraInfo,
	}
}

func (msg *MsgCreateTrade) Route() string {
	return RouterKey
}

func (msg *MsgCreateTrade) Type() string {
	return "CreateTrade"
}

func (msg *MsgCreateTrade) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgCreateTrade) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgCreateTrade) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	if !(msg.CoinInput.Denom == "") && !msg.CoinInput.IsValid() {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "invalid coinInput")
	}

	if !(msg.CoinOutput.Denom == "") && !msg.CoinOutput.IsValid() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, "invalid coinOutput")
	}

	if !(msg.CoinInput.Denom == "") && !(msg.CoinOutput.Denom == "") && msg.CoinOutput.Denom != msg.CoinInput.Denom {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, "coin input and coin output denoms must match")
	}

	for _, item := range msg.ItemOutputs {
		err := ValidateNumber(item.ItemID)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		err = ValidateID(item.CookbookID)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	for _, ii := range msg.ItemInputs {
		if err = ValidateItemInput(ii); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	return nil
}

var _ sdk.Msg = &MsgCancelTrade{}

func NewMsgCancelTrade(creator string, id uint64) *MsgCancelTrade {
	return &MsgCancelTrade{
		ID:      id,
		Creator: creator,
	}
}
func (msg *MsgCancelTrade) Route() string {
	return RouterKey
}

func (msg *MsgCancelTrade) Type() string {
	return "CancelTrade"
}

func (msg *MsgCancelTrade) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgCancelTrade) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgCancelTrade) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	return nil
}

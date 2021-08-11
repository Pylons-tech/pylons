package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgSendItems{}

func NewMsgSendItems(sender string, receiver string, cookbookID string, recipeID string, itemIDs []string) *MsgSendItems {
	return &MsgSendItems{
		Creator:    sender,
		Receiver:   receiver,
		CookbookID: cookbookID,
		RecipeID:   recipeID,
		ItemIDs:    itemIDs,
	}
}

func (msg *MsgSendItems) Route() string {
	return RouterKey
}

func (msg *MsgSendItems) Type() string {
	return "SendItems"
}

func (msg *MsgSendItems) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgSendItems) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgSendItems) ValidateBasic() error {
	// Validate Sender and receiver addresses
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	_, err = sdk.AccAddressFromBech32(msg.Receiver)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid receiver address (%s)", err)
	}

	if err = ValidateID(msg.CookbookID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	if err = ValidateID(msg.RecipeID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	for _, id := range msg.ItemIDs {
		if err = ValidateNumber(id); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}
	return nil
}

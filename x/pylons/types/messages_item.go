package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateItem{}

func NewMsgCreateItem(creator string, id string, cookbookID string, nodeVersion string, doubles []DoubleKeyValue, longs []LongKeyValue, strings []StringKeyValue, ownerRecipeID string, ownerTradeID string, tradeable bool, lastUpdate uint64, transferFee uint64) *MsgCreateItem {
	return &MsgCreateItem{
		Creator:       creator,
		ID:         	id,
		CookbookID:    cookbookID,
		NodeVersion:   nodeVersion,
		Doubles:       doubles,
		Longs:         longs,
		Strings:       strings,
		OwnerRecipeID: ownerRecipeID,
		OwnerTradeID:  ownerTradeID,
		Tradable:      tradeable,
		LastUpdate:    lastUpdate,
		TransferFee:   transferFee,
	}
}

func (msg *MsgCreateItem) Route() string {
	return RouterKey
}

func (msg *MsgCreateItem) Type() string {
	return "CreateItem"
}

func (msg *MsgCreateItem) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgCreateItem) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgCreateItem) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	return nil
}

var _ sdk.Msg = &MsgUpdateItem{}

func NewMsgUpdateItem(creator string, id string, cookbookID string, nodeVersion string, doubles []DoubleKeyValue, longs []LongKeyValue, strings []StringKeyValue, ownerRecipeID string, ownerTradeID string, tradeable bool, lastUpdate uint64, transferFee uint64) *MsgUpdateItem {
	return &MsgUpdateItem{
		Creator:       creator,
		ID:            id,
		CookbookID:    cookbookID,
		NodeVersion:   nodeVersion,
		Doubles:       doubles,
		Longs:         longs,
		Strings:       strings,
		OwnerRecipeID: ownerRecipeID,
		OwnerTradeID:  ownerTradeID,
		Tradable:      tradeable,
		LastUpdate:    lastUpdate,
		TransferFee:   transferFee,
	}
}

func (msg *MsgUpdateItem) Route() string {
	return RouterKey
}

func (msg *MsgUpdateItem) Type() string {
	return "UpdateItem"
}

func (msg *MsgUpdateItem) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgUpdateItem) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgUpdateItem) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	return nil
}

var _ sdk.Msg = &MsgDeleteItem{}

func NewMsgDeleteItem(creator string, id string) *MsgDeleteItem {
	return &MsgDeleteItem{
		Creator: creator,
		ID:   id,
	}
}
func (msg *MsgDeleteItem) Route() string {
	return RouterKey
}

func (msg *MsgDeleteItem) Type() string {
	return "DeleteItem"
}

func (msg *MsgDeleteItem) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgDeleteItem) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgDeleteItem) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	return nil
}

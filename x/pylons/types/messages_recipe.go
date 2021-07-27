package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateRecipe{}

func NewMsgCreateRecipe(creator string, index string, nodeVersion string, cookbookID string, name string, coinInput sdk.Coins, itemInput []ItemInput, entries EntriesList, weightedOutputs []WeightedOutputs, description string, blockInterval uint64, enabled bool, extraInfo string) *MsgCreateRecipe {
	return &MsgCreateRecipe{
		Creator:         creator,
		Index:           index,
		NodeVersion:     nodeVersion,
		CookbookID:      cookbookID,
		Name:            name,
		CoinInputs:      coinInput,
		ItemInputs:      itemInput,
		Entries:         entries,
		Outputs: 		 weightedOutputs,
		Description:     description,
		BlockInterval:   blockInterval,
		Enabled:         enabled,
		ExtraInfo:       extraInfo,
	}
}

func (msg *MsgCreateRecipe) Route() string {
	return RouterKey
}

func (msg *MsgCreateRecipe) Type() string {
	return "CreateRecipe"
}

func (msg *MsgCreateRecipe) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgCreateRecipe) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgCreateRecipe) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	return nil
}

var _ sdk.Msg = &MsgUpdateRecipe{}

func NewMsgUpdateRecipe(creator string, index string, nodeVersion string, cookbookID string, name string, coinInput sdk.Coins, itemInput []ItemInput, entries EntriesList, weightedOutputs []WeightedOutputs, description string, blockInterval uint64, enabled bool, extraInfo string) *MsgUpdateRecipe {
	return &MsgUpdateRecipe{
		Creator:         creator,
		Index:           index,
		NodeVersion:     nodeVersion,
		CookbookID:      cookbookID,
		Name:            name,
		CoinInputs:      coinInput,
		ItemInputs:      itemInput,
		Entries:         entries,
		Outputs: 		 weightedOutputs,
		Description:     description,
		BlockInterval:   blockInterval,
		Enabled:         enabled,
		ExtraInfo:       extraInfo,
	}
}

func (msg *MsgUpdateRecipe) Route() string {
	return RouterKey
}

func (msg *MsgUpdateRecipe) Type() string {
	return "UpdateRecipe"
}

func (msg *MsgUpdateRecipe) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgUpdateRecipe) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgUpdateRecipe) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	return nil
}

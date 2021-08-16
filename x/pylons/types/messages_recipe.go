package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgCreateRecipe{}

func NewMsgCreateRecipe(creator string, cookbookID string, id string, name string, description string, version string, coinInput sdk.Coins, itemInput []ItemInput, entries EntriesList, weightedOutputs []WeightedOutputs, blockInterval uint64, enabled bool, extraInfo string) *MsgCreateRecipe {
	return &MsgCreateRecipe{
		Creator:       creator,
		CookbookID:    cookbookID,
		ID:            id,
		Name:          name,
		Description:   description,
		Version:       version,
		CoinInputs:    coinInput,
		ItemInputs:    itemInput,
		Entries:       entries,
		Outputs:       weightedOutputs,
		BlockInterval: blockInterval,
		Enabled:       enabled,
		ExtraInfo:     extraInfo,
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

	if err = ValidateID(msg.CookbookID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateID(msg.ID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if !msg.CoinInputs.Empty() {
		// Validate sdk coins
		if !msg.CoinInputs.IsValid() {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, msg.CoinInputs.String())
		}

		if !msg.CoinInputs.IsAllPositive() {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, msg.CoinInputs.String())
		}
	}

	for _, ii := range msg.ItemInputs {
		if err = ValidateItemInput(ii); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	idMap := make(map[string]bool)
	if err = ValidateEntriesList(msg.Entries, idMap); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	for _, o := range msg.Outputs {
		if err = ValidateOutputs(o, idMap); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	return nil
}

var _ sdk.Msg = &MsgUpdateRecipe{}

func NewMsgUpdateRecipe(creator string, cookbookID string, id string, name string, description string, version string, coinInput sdk.Coins, itemInput []ItemInput, entries EntriesList, weightedOutputs []WeightedOutputs, blockInterval uint64, enabled bool, extraInfo string) *MsgUpdateRecipe {
	return &MsgUpdateRecipe{
		Creator:       creator,
		CookbookID:    cookbookID,
		ID:            id,
		Name:          name,
		Description:   description,
		Version:       version,
		CoinInputs:    coinInput,
		ItemInputs:    itemInput,
		Entries:       entries,
		Outputs:       weightedOutputs,
		BlockInterval: blockInterval,
		Enabled:       enabled,
		ExtraInfo:     extraInfo,
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

	if err = ValidateID(msg.CookbookID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateID(msg.ID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err = ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if !msg.CoinInputs.Empty() {
		// Validate sdk coins
		if !msg.CoinInputs.IsValid() {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, msg.CoinInputs.String())
		}

		if !msg.CoinInputs.IsAllPositive() {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, msg.CoinInputs.String())
		}
	}

	for _, ii := range msg.ItemInputs {
		if err = ValidateItemInput(ii); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	idMap := make(map[string]bool)
	if err = ValidateEntriesList(msg.Entries, idMap); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	for _, o := range msg.Outputs {
		if err = ValidateOutputs(o, idMap); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	return nil
}

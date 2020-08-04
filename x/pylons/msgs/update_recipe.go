package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgUpdateRecipe defines a UpdateRecipe message
type MsgUpdateRecipe struct {
	Name          string
	CookbookID    string // the cookbook guid
	ID            string // the recipe guid
	CoinInputs    types.CoinInputList
	ItemInputs    types.ItemInputList
	Entries       types.EntriesList
	Outputs       types.WeightedOutputsList
	BlockInterval int64
	Sender        sdk.AccAddress
	Description   string
}

// NewMsgUpdateRecipe a constructor for UpdateRecipe msg
func NewMsgUpdateRecipe(recipeName, cookbookID, id, description string,
	coinInputs types.CoinInputList,
	itemInputs types.ItemInputList,
	entries types.EntriesList,
	outputs types.WeightedOutputsList,
	blockInterval int64,
	sender sdk.AccAddress) MsgUpdateRecipe {
	return MsgUpdateRecipe{
		Name:          recipeName,
		ID:            id,
		CookbookID:    cookbookID,
		Description:   description,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		Outputs:       outputs,
		BlockInterval: blockInterval,
		Sender:        sender,
	}
}

// Route should return the name of the module
func (msg MsgUpdateRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgUpdateRecipe) Type() string { return "update_recipe" }

// ValidateBasic validates the Msg
func (msg MsgUpdateRecipe) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())

	}

	if len(msg.ID) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the id for the recipe require to update it")
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	msgCreateRecipe := NewMsgCreateRecipe(
		msg.Name,
		msg.CookbookID,
		msg.ID,
		msg.Description,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.Entries,
		msg.Outputs,
		msg.BlockInterval,
		msg.Sender,
	)

	return msgCreateRecipe.ValidateBasic()
}

// GetSignBytes encodes the message for signing
func (msg MsgUpdateRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgUpdateRecipe) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}

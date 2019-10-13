package msgs

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgUpdateRecipe defines a UpdateRecipe message
type MsgUpdateRecipe struct {
	RecipeName    string
	CookbookId    string // the cookbook guid
	ID            string // the recipe guid
	CoinInputs    types.CoinInputList
	ItemInputs    types.ItemInputList
	Entries       types.WeightedParamList
	BlockInterval int64
	Sender        sdk.AccAddress
	Description   string
}

// NewMsgUpdateRecipe a constructor for UpdateRecipe msg
func NewMsgUpdateRecipe(recipeName, cookbookId, id, description string,
	coinInputs types.CoinInputList,
	itemInputs types.ItemInputList,
	entries types.WeightedParamList,
	sender sdk.AccAddress) MsgUpdateRecipe {
	return MsgUpdateRecipe{
		RecipeName:    recipeName,
		ID:            id,
		CookbookId:    cookbookId,
		Description:   description,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		BlockInterval: 0,
		Sender:        sender,
	}
}

// Route should return the name of the module
func (msg MsgUpdateRecipe) Route() string { return "pylons" }

// Type should return the action
func (msg MsgUpdateRecipe) Type() string { return "update_recipe" }

// ValidateBasic validates the Msg
func (msg MsgUpdateRecipe) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	if len(msg.ID) == 0 {
		return sdk.ErrInternal("the id for the recipe require to update it")
	}

	if len(msg.Description) < 20 {
		return sdk.ErrInternal("the description should have more than 20 characters")
	}

	return nil
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

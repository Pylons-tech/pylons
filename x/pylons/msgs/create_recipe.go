package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgCreateRecipe defines a CreateRecipe message
type MsgCreateRecipe struct {
	// optional RecipeID if someone
	RecipeID      string `json:",omitempty"`
	Name          string
	CookbookID    string // the cookbook guid
	CoinInputs    types.CoinInputList
	ItemInputs    types.ItemInputList
	Entries       types.EntriesList
	Outputs       types.WeightedOutputsList
	BlockInterval int64
	Sender        sdk.AccAddress
	Description   string
}

// NewMsgCreateRecipe a constructor for CreateRecipe msg
func NewMsgCreateRecipe(recipeName, cookbookID, recipeID, description string,
	coinInputs types.CoinInputList,
	itemInputs types.ItemInputList,
	entries types.EntriesList,
	outputs types.WeightedOutputsList,
	blockInterval int64,
	sender sdk.AccAddress) MsgCreateRecipe {
	return MsgCreateRecipe{
		Name:          recipeName,
		CookbookID:    cookbookID,
		RecipeID:      recipeID,
		Description:   description,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		Outputs:       outputs,
		BlockInterval: int64(blockInterval),
		Sender:        sender,
	}
}

// Route should return the name of the module
func (msg MsgCreateRecipe) Route() string { return "pylons" }

// Type should return the action
func (msg MsgCreateRecipe) Type() string { return "create_recipe" }

// ValidateBasic validates the Msg
func (msg MsgCreateRecipe) ValidateBasic() sdk.Error {
	// TODO should basic validation for the item input index overflow on item outputs
	// TODO should do basic validation for program of ItemOutput and ToModify
	// TODO there shoud be validation for same ItemInputRef on entries

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	if len(msg.Description) < 20 {
		return sdk.ErrInternal("the description should have more than 20 characters")
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCreateRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgCreateRecipe) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}

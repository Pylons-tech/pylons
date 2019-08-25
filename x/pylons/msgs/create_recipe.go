package msgs

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgCreateRecipe defines a SetName message
type MsgCreateRecipe struct {
	RecipeName    string
	CookbookName  string // the cookbook guid
	ID            string // the recipe guid
	Inputs        types.InputList
	Outputs       types.OutputList
	ExecutionTime int64
	Sender        sdk.AccAddress
	Description   string
}

// NewMsgCreateRecipe a constructor for CreateCookbook msg
func NewMsgCreateRecipe(recipeName, cookbookName, description string, inputs types.InputList, outputs types.OutputList, sender sdk.AccAddress) MsgCreateRecipe {
	return MsgCreateRecipe{
		RecipeName:    recipeName,
		CookbookName:  cookbookName,
		Description:   description,
		Inputs:        inputs,
		Outputs:       outputs,
		ExecutionTime: 0,
		Sender:        sender,
	}
}

// Route should return the name of the module
func (msg MsgCreateRecipe) Route() string { return "pylons" }

// Type should return the action
func (msg MsgCreateRecipe) Type() string { return "create_recipe" }

// ValidateBasic validates the Msg
func (msg MsgCreateRecipe) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	if len(msg.CookbookName) < 8 {
		return sdk.ErrInternal("the name of the cookbook should have more than 8 characters")
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

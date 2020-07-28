package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
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
func (msg MsgCreateRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateRecipe) Type() string { return "create_recipe" }

// ValidateBasic validates the Msg
func (msg MsgCreateRecipe) ValidateBasic() error {

	// validation for the item input index overflow on entries
	for _, entry := range msg.Entries {
		switch entry := entry.(type) {
		case types.CoinOutput:
			coinOutput := entry
			if err := types.ProgramValidateBasic(coinOutput.Count); err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "CoinOuput: "+err.Error())
			}
			if coinOutput.Coin == types.Pylon {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "There should not be a recipe which generate pylon denom as an output")
			}
		case types.ItemModifyOutput:
			if entry.ItemInputRef >= len(msg.ItemInputs) {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "ItemInputRef overflow length of ItemInputs")
			}
			if entry.ItemInputRef < -1 {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "ItemInputRef is less than 0 which is invalid")
			}
		case types.ItemOutput:
			// do nothing for now
		default:
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid entry type available")
		}
	}

	for _, output := range msg.Outputs {
		// validation for same ItemInputRef on output
		usedItemInputRefs := make(map[int]bool)
		usedEntries := make(map[int]bool)
		for _, result := range output.ResultEntries {
			if result >= len(msg.Entries) || result < 0 {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "output is refering to index which is out of entries range")
			}
			if usedEntries[result] {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "double use of entries within single output result")
			}
			usedEntries[result] = true
			entry := msg.Entries[result]
			switch entry := entry.(type) {
			case types.ItemModifyOutput:
				if usedItemInputRefs[entry.ItemInputRef] {
					return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "double use of item input within single output result")
				}
				usedItemInputRefs[entry.ItemInputRef] = true
			}
		}
		// validation for weight program
		if err := types.ProgramValidateBasic(output.Weight); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Output Weight: "+err.Error())
		}
	}

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
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

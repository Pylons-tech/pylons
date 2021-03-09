package msgs

import (
	"encoding/json"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgCreateRecipe a constructor for CreateRecipe msg
func NewMsgCreateRecipe(recipeName, cookbookID, recipeID, description string,
	coinInputs *types.CoinInputList,
	itemInputs *types.ItemInputList,
	entries *types.EntriesList,
	outputs *types.WeightedOutputsList,
	blockInterval int64,
	sender string) MsgCreateRecipe {
	return MsgCreateRecipe{
		RecipeID:      recipeID,
		Name:          recipeName,
		CookbookID:    cookbookID,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Outputs:       outputs,
		BlockInterval: blockInterval,
		Sender:        sender,
		Description:   description,
		Entries:       entries,
	}
}

// Route should return the name of the module
func (msg MsgCreateRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateRecipe) Type() string { return "create_recipe" }

// ValidateBasic validates the Msg
func (msg MsgCreateRecipe) ValidateBasic() error {

	itemInputRefsMap := map[string]bool{}
	entryIDsMap := map[string]bool{}
	for _, ii := range msg.ItemInputs.List {
		if ii.ID == "" {
			continue
		}
		if err := ii.IDValidationError(); err != nil {
			return err
		}
		if itemInputRefsMap[ii.ID] {
			return fmt.Errorf("item input with same ID available: ID=%s", ii.ID)
		}
		itemInputRefsMap[ii.ID] = true
	}

	// validation for the invalid item input reference on a coins outputs
	for _, entry := range msg.Entries.CoinOutputs {
		if err := types.EntryIDValidationError(entry.GetID()); err != nil {
			return err
		}
		if entryIDsMap[entry.GetID()] {
			return fmt.Errorf("entry with same ID available: ID=%s", entry.GetID())
		}
		entryIDsMap[entry.GetID()] = true
		coinOutput := entry
		if err := types.ProgramValidateBasic(coinOutput.Count); err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "CoinOuput: "+err.Error())
		}
		if coinOutput.Coin == types.Pylon {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "There should not be a recipe which generate pylon denom as an output")
		}
		if err := sdk.ValidateDenom(coinOutput.Coin); err != nil {
			return err
		}
	}

	// validation for the invalid item input reference on a items with modified outputs
	for _, entry := range msg.Entries.ItemModifyOutputs {
		if err := types.EntryIDValidationError(entry.GetID()); err != nil {
			return err
		}
		if entryIDsMap[entry.GetID()] {
			return fmt.Errorf("entry with same ID available: ID=%s", entry.GetID())
		}
		entryIDsMap[entry.GetID()] = true
		if !itemInputRefsMap[entry.ItemInputRef] {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Invalid item input ref found that does not exist in item inputs")
		}
	}
	// do nothing for now for items outputs

	for _, output := range msg.Outputs.List {
		// validation for same ItemInputRef on output
		usedItemInputRefs := make(map[string]bool)
		usedEntries := make(map[string]bool)
		for _, entryID := range output.EntryIDs {
			entry, err := msg.Entries.FindByID(entryID)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			if usedEntries[entryID] {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "double use of entries within single output result")
			}
			usedEntries[entryID] = true
			switch entry := entry.(type) {
			case *types.ItemModifyOutput:
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

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
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
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgUpdateRecipe a constructor for UpdateRecipe msg
func NewMsgUpdateRecipe(id, recipeName, cookbookID, description string,
	coinInputs types.CoinInputList,
	itemInputs types.ItemInputList,
	entries types.EntriesList,
	outputs types.WeightedOutputsList,
	blockInterval int64,
	sender sdk.AccAddress) MsgUpdateRecipe {
	return MsgUpdateRecipe{
		ID:            id,
		Name:          recipeName,
		CookbookID:    cookbookID,
		Description:   description,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		Outputs:       outputs,
		BlockInterval: blockInterval,
		Sender:        sender.String(),
	}
}

// Route should return the name of the module
func (msg MsgUpdateRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgUpdateRecipe) Type() string { return "update_recipe" }

// ValidateBasic validates the Msg
func (msg MsgUpdateRecipe) ValidateBasic() error {
	if len(msg.ID) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "recipe id is required for this message type")
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
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

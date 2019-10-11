package msgs

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgCreateTrade defines a CreateTrade message
type MsgCreateTrade struct {
	TradeName     string
	CoinInputs    types.CoinInputList
	ItemInputs    types.ItemInputList
	Entries       types.WeightedParamList
	BlockInterval int64
	Sender        sdk.AccAddress
	Description   string
}

// NewMsgCreateTrade a constructor for CreateTrade msg
func NewMsgCreateTrade(tradeName, description string,
	coinInputs types.CoinInputList,
	itemInputs types.ItemInputList,
	entries types.WeightedParamList,
	blockInterval int,
	sender sdk.AccAddress) MsgCreateTrade {
	return MsgCreateTrade{
		TradeName:     tradeName,
		Description:   description,
		CoinInputs:    coinInputs,
		ItemInputs:    itemInputs,
		Entries:       entries,
		BlockInterval: int64(blockInterval),
		Sender:        sender,
	}
}

// Route should return the name of the module
func (msg MsgCreateTrade) Route() string { return "pylons" }

// Type should return the action
func (msg MsgCreateTrade) Type() string { return "create_trade" }

// ValidateBasic validates the Msg
func (msg MsgCreateTrade) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	if len(msg.Description) < 20 {
		return sdk.ErrInternal("the description should have more than 20 characters")
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCreateTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgCreateTrade) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}

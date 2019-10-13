package msgs

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type MsgDropItem struct {
	Doubles    []types.DoubleKeyValue
	Longs      []types.LongKeyValue
	Strings    []types.StringKeyValue
	CookbookID string
	Sender     sdk.AccAddress
}

// MsgDropItem a constructor for ExecuteCookbook msg
func NewMsgDropItem(cookbookID string, doubles []types.DoubleKeyValue, longs []types.LongKeyValue, strings []types.StringKeyValue, sender sdk.AccAddress) MsgDropItem {
	return MsgDropItem{
		CookbookID: cookbookID,
		Doubles:    doubles,
		Longs:      longs,
		Strings:    strings,
		Sender:     sender,
	}
}

// Route should return the name of the module
func (msg MsgDropItem) Route() string { return "pylons" }

// Type should return the action
func (msg MsgDropItem) Type() string { return "drop_item" }

// ValidateBasic validates the Msg
func (msg MsgDropItem) ValidateBasic() sdk.Error {
	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgDropItem) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgDropItem) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}

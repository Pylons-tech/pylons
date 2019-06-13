package msgs

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgUpdateCookbook defines a SetName message
type MsgUpdateCookbook struct {
	ID           string
	Description  string
	Version      types.SemVer
	Developer    string
	SupportEmail types.Email
	Level        types.Level
	Sender       sdk.AccAddress
}

// NewMsgUpdateCookbook a constructor for UpdateCookbook msg
func NewMsgUpdateCookbook(ID, desc, devel string, version types.SemVer, sEmail types.Email, sender sdk.AccAddress) MsgUpdateCookbook {
	return MsgUpdateCookbook{
		ID:           ID,
		Description:  desc,
		Developer:    devel,
		Version:      version,
		SupportEmail: sEmail,
		Sender:       sender,
	}
}

// Route should return the name of the module
func (msg MsgUpdateCookbook) Route() string { return "pylons" }

// Type should return the action
func (msg MsgUpdateCookbook) Type() string { return "update_cookbook" }

// ValidateBasic validates the Msg
func (msg MsgUpdateCookbook) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	if msg.ID == "" {
		return sdk.ErrInternal("the id of the cookbook should not be blank")
	}

	if len(msg.Description) < 20 {
		return sdk.ErrInternal("the description should have more than 20 characters")
	}

	if err := msg.SupportEmail.Validate(); err != nil {
		return sdk.ErrInternal(err.Error())
	}

	if err := msg.Version.Validate(); err != nil {
		return sdk.ErrInternal(err.Error())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgUpdateCookbook) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgUpdateCookbook) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}

package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgUpdateCookbook defines a UpdateCookbook message
type MsgUpdateCookbook struct {
	ID           string
	Description  string
	Version      types.SemVer
	Developer    string
	SupportEmail types.Email
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
func (msg MsgUpdateCookbook) Route() string { return RouterKey }

// Type should return the action
func (msg MsgUpdateCookbook) Type() string { return "update_cookbook" }

// ValidateBasic validates the Msg
func (msg MsgUpdateCookbook) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())
	}

	if msg.ID == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the id of the cookbook should not be blank")
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	if err := msg.SupportEmail.Validate(); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err := msg.Version.Validate(); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
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

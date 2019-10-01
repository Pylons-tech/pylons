package msgs

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// DefaultCostPerBlock the amount of pylons to be charged by default
const DefaultCostPerBlock = 50 // Pylons

// MsgCreateCookbook defines a SetName message
type MsgCreateCookbook struct {
	Name         string
	Description  string
	Version      types.SemVer
	Developer    string
	SupportEmail types.Email
	Level        types.Level
	Sender       sdk.AccAddress
	// Pylons per block to be charged across this cookbook for delayed execution early completion
	CostPerBlock *int `json:",omitempty"`
}

// NewMsgCreateCookbook a constructor for CreateCookbook msg
func NewMsgCreateCookbook(name, desc, devel string, version types.SemVer, sEmail types.Email, level types.Level, cpb int, sender sdk.AccAddress) MsgCreateCookbook {
	return MsgCreateCookbook{
		Name:         name,
		Description:  desc,
		Developer:    devel,
		Version:      version,
		SupportEmail: sEmail,
		Level:        level,
		Sender:       sender,
		CostPerBlock: &cpb,
	}
}

// Route should return the name of the module
func (msg MsgCreateCookbook) Route() string { return "pylons" }

// Type should return the action
func (msg MsgCreateCookbook) Type() string { return "create_cookbook" }

// ValidateBasic validates the Msg
func (msg MsgCreateCookbook) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	if len(msg.Name) < 8 {
		return sdk.ErrInternal("the name of the cookbook should have more than 8 characters")
	}

	if len(msg.Description) < 20 {
		return sdk.ErrInternal("the description should have more than 20 characters")
	}

	if err := msg.SupportEmail.Validate(); err != nil {
		return sdk.ErrInternal(err.Error())
	}

	if err := msg.Level.Validate(); err != nil {
		return sdk.ErrInternal(err.Error())
	}

	if err := msg.Version.Validate(); err != nil {
		return sdk.ErrInternal(err.Error())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCreateCookbook) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgCreateCookbook) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}

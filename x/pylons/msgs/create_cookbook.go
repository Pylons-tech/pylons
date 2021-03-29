package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// DefaultCostPerBlock the amount of pylons to be charged by default
const DefaultCostPerBlock = 50 // Pylons

// NewMsgCreateCookbook a constructor for CreateCookbook msg
func NewMsgCreateCookbook(name, cookbookID, desc, developer string, version string, sEmail string, level int64, cpb int64, sender sdk.AccAddress) MsgCreateCookbook {
	return MsgCreateCookbook{
		CookbookID:   cookbookID,
		Name:         name,
		Description:  desc,
		Developer:    developer,
		Version:      version,
		SupportEmail: sEmail,
		Level:        level,
		Sender:       sender.String(),
		CostPerBlock: cpb,
	}
}

// Route should return the name of the module
func (msg MsgCreateCookbook) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateCookbook) Type() string { return "create_cookbook" }

// ValidateBasic validates the Msg
func (msg MsgCreateCookbook) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if len(msg.Name) < 8 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the name of the cookbook should have more than 8 characters")
	}

	if len(msg.Description) < 20 {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the description should have more than 20 characters")
	}

	if err := types.ValidateEmail(msg.SupportEmail); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err := types.ValidateLevel(msg.Level); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if err := types.ValidateVersion(msg.Version); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
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
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

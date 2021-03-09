package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgCreateAccount is a function to get MsgCreateAccount msg from required params
func NewMsgCreateAccount(requester sdk.AccAddress) MsgCreateAccount {
	return MsgCreateAccount{
		Requester: requester.String(),
	}
}

// Route should return the name of the module
func (msg MsgCreateAccount) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateAccount) Type() string { return "create_account" }

// ValidateBasic is a function to validate MsgCreateAccount msg
func (msg MsgCreateAccount) ValidateBasic() error {

	if msg.Requester == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Requester)
	}
	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCreateAccount) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners encodes the message for signing
func (msg MsgCreateAccount) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Requester)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}

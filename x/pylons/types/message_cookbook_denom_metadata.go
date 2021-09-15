package types

import (
	"strings"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
)

var _ sdk.Msg = &MsgSetCookbookDenomMetadata{}

func NewMsgSetCookbookDenomMetadata(creator string, cookbookID string, denom string, description string, denomUnits []banktypes.DenomUnit, base string, display string) *MsgSetCookbookDenomMetadata {
	return &MsgSetCookbookDenomMetadata{
		Creator:     creator,
		CookbookID:  cookbookID,
		Denom:       denom,
		Description: description,
		DenomUnits:  denomUnits,
		Base:        base,
		Display:     display,
	}
}

func (msg *MsgSetCookbookDenomMetadata) Route() string {
	return RouterKey
}

func (msg *MsgSetCookbookDenomMetadata) Type() string {
	return "CreateCookbookDenomMetadata"
}

func (msg *MsgSetCookbookDenomMetadata) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgSetCookbookDenomMetadata) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgSetCookbookDenomMetadata) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}

	// validate cookbookID
	if err = ValidateID(msg.CookbookID); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	// validate denom AND
	// check if it is a cookbookDenom AND not an IBC denom
	coin := sdk.Coin{Denom: msg.Denom, Amount: sdk.OneInt()}
	if err = coin.Validate(); err != nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if !IsCookbookDenom(msg.Denom) {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "denom %s is not a valid cookbookDenom", msg.Denom)
	}

	if IsIBCDenomRepresentation(msg.Denom) {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "denom %s is an ibc transfer denom of form ibc/{hash}", msg.Denom)
	}

	// check that the cookbookID is the denom cookbookID
	split := strings.Split(msg.Denom, denomDivider)
	if split[0] != msg.CookbookID {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "denom %s cookbookID does not match message cookbookID %s", msg.Denom, msg.CookbookID)
	}

	// do nothing with description

	// validate denomUnits
	// check  BASE and DISPLAY
	// make sure both are valid denoms in denomUNITss
	if len(msg.DenomUnits) > 0 {
		baseFound := false
		displayFound := false
		for _, denomUnit := range msg.DenomUnits {
			if err = denomUnit.Validate(); err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			if denomUnit.Denom == msg.Base {
				baseFound = true
			}
			if denomUnit.Denom == msg.Display {
				displayFound = true
			}
		}

		if !(baseFound && displayFound) {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "denomUnits do not contain base or display denoms")
		}
	}

	return nil
}

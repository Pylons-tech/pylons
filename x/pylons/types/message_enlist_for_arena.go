package types

import (
	//"fmt"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

var _ sdk.Msg = &MsgEnlistForArena{}

func NewMsgEnlistForArena(creator string, opponent string, cookbookID string, lHitem string, rHitem string, armoritem string) *MsgEnlistForArena {
	return &MsgEnlistForArena{
		Creator:    creator,
		Opponent:   opponent,
		CookbookID: cookbookID,
		LHitem:     lHitem,
		RHitem:     rHitem,
		Armoritem:  armoritem,
	}
}

func (msg *MsgEnlistForArena) Route() string {
	return RouterKey
}

func (msg *MsgEnlistForArena) Type() string {
	return "EnlistForArena"
}

func (msg *MsgEnlistForArena) GetSigners() []sdk.AccAddress {
	creator, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{creator}
}

func (msg *MsgEnlistForArena) GetSignBytes() []byte {
	bz := ModuleCdc.MustMarshalJSON(msg)
	return sdk.MustSortJSON(bz)
}

func (msg *MsgEnlistForArena) ValidateBasic() error {
	_, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidAddress, "invalid creator address (%s)", err)
	}
	/*
		items := []string{msg.LHitem, msg.RHitem, msg.Armoritem}


		for _, itemIDstring := range items {
			fmt.Println(itemIDstring)
			err := ValidateItemID(itemIDstring)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			err = ValidateID(msg.CookbookID)
			if err != nil {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
		}
	*/

	return nil
}

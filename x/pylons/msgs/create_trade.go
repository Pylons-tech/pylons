package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgCreateTrade defines a CreateTrade message
type MsgCreateTrade struct {
	CoinInputs  types.CoinInputList
	ItemInputs  types.ItemInputList
	CoinOutputs sdk.Coins
	ItemOutputs types.ItemList
	ExtraInfo   string
	Sender      sdk.AccAddress
}

// NewMsgCreateTrade a constructor for CreateTrade msg
func NewMsgCreateTrade(
	coinInputs types.CoinInputList,
	itemInputs types.ItemInputList,
	coinOutputs sdk.Coins,
	itemOutputs types.ItemList,
	extraInfo string,
	sender sdk.AccAddress) MsgCreateTrade {
	return MsgCreateTrade{
		CoinInputs:  coinInputs,
		ItemInputs:  itemInputs,
		CoinOutputs: coinOutputs,
		ItemOutputs: itemOutputs,
		ExtraInfo:   extraInfo,
		Sender:      sender,
	}
}

// Route should return the name of the module
func (msg MsgCreateTrade) Route() string { return "pylons" }

// Type should return the action
func (msg MsgCreateTrade) Type() string { return "create_trade" }

// ValidateBasic validates the Msg
func (msg MsgCreateTrade) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())

	}
	if msg.CoinOutputs == nil && msg.ItemOutputs == nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "sender not providing anything in exchange of the trade: empty outputs")
	}

	if msg.CoinOutputs != nil {
		for _, coinOutput := range msg.CoinOutputs {
			if !coinOutput.IsPositive() {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "there should be no 0 amount denom on outputs")
			}
		}
	}

	if msg.ItemInputs == nil && msg.CoinInputs == nil {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "sender not receiving anything for the trade: empty inputs")
	}

	if msg.CoinInputs != nil {
		for _, coinInput := range msg.CoinInputs {
			if coinInput.Count == 0 {
				return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "there should be no 0 amount denom on coin inputs")
			}
		}
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

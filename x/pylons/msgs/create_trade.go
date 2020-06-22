package msgs

import (
	"encoding/json"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgCreateTrade defines a CreateTrade message
type MsgCreateTrade struct {
	CoinInputs  types.CoinInputList
	ItemInputs  types.TradeItemInputList
	CoinOutputs sdk.Coins
	ItemOutputs types.ItemList
	ExtraInfo   string
	Sender      sdk.AccAddress
}

// NewMsgCreateTrade a constructor for CreateTrade msg
func NewMsgCreateTrade(
	coinInputs types.CoinInputList,
	itemInputs types.TradeItemInputList,
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
func (msg MsgCreateTrade) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCreateTrade) Type() string { return "create_trade" }

// ValidateBasic validates the Msg
func (msg MsgCreateTrade) ValidateBasic() error {
	tradePylonAmount := int64(0)

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
		tradePylonAmount += msg.CoinOutputs.AmountOf(types.Pylon).Int64()
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
		tradePylonAmount += msg.CoinInputs.ToCoins().AmountOf(types.Pylon).Int64()
	}

	if tradePylonAmount < config.Config.Fee.MinTradePrice {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("there should be more than %d amount of pylon per trade", config.Config.Fee.MinTradePrice))
	}

	if msg.ItemInputs != nil {
		err := msg.ItemInputs.Validate()
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
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

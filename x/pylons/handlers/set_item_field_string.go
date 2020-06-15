package handlers

import (
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// UpdateItemStringResponse is a struct to control update item string response
type UpdateItemStringResponse struct {
	Status  string
	Message string
}

// HandlerMsgUpdateItemString is used to transact pylons between people
func HandlerMsgUpdateItemString(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgUpdateItemString) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	updateFee := types.NewPylon(int64(len(msg.Value)))
	fmt.Println(keeper.CoinKeeper.GetCoins(ctx, msg.Sender))
	fmt.Println(updateFee)
	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, updateFee) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Sender does not have enough coins for this action")
	}

	_, subErr := keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, updateFee)
	if subErr != nil {
		return nil, errInternal(subErr)
	}

	item, err := keeper.GetItem(ctx, msg.ItemID)
	if err != nil {
		return nil, errInternal(err)
	}

	keyID, ok := item.FindStringKey(msg.Field)
	if !ok {
		return nil, errInternal(errors.New("Provided field does not exist within the item"))
	}

	item.Strings[keyID].Value = msg.Value

	if err := keeper.SetItem(ctx, item); err != nil {
		return nil, errInternal(errors.New("Error updating item inside keeper"))
	}

	return marshalJSON(CheckExecutionResponse{
		Message: "successfully updated the item field",
		Status:  "Success",
	})
}

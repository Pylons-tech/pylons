package handlers

import (
	"math/rand"
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

type UpdateItemStringResp struct {
	Status  string
	Message string
}

// HandleMsgUpdateItemString is used to transact pylons between people
func HandleMsgUpdateItemString(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgUpdateItemString) (*sdk.Result, error) {
	// set random seed at the start point of handler
	rand.Seed(types.RandomSeed(ctx))
	
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

	keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, updateFee)

	item, err2 := keeper.GetItem(ctx, msg.ItemID)
	if err2 != nil {
		return nil, errInternal(err)
	}

	kID, ok := item.FindStringKey(msg.Field)
	if !ok {
		return nil, errInternal(errors.New("Provided field does not exist within the item"))
	}

	item.Strings[kID].Value = msg.Value

	if err := keeper.SetItem(ctx, item); err != nil {
		return nil, errInternal(errors.New("Error updating item inside keeper"))
	}

	return marshalJson(CheckExecutionResp{
		Message: "successfully updated the item field",
		Status:  "Success",
	})
}

package handlers

import (
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type SetItemFieldStringResp struct {
	Status  string
	Message string
}

// HandleMsgSetItemFieldString is used to transact pylons between people
func HandleMsgSetItemFieldString(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgSetItemFieldString) sdk.Result {

	err := msg.ValidateBasic()

	if err != nil {
		return err.Result()
	}

	updateFee := types.NewPylon(int64(len(msg.Value)))
	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, updateFee) {
		return sdk.ErrInsufficientCoins("Sender does not have enough coins for this action").Result()
	}

	keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, updateFee)

	item, err2 := keeper.GetItem(ctx, msg.ItemID)
	if err2 != nil {
		return err.Result()
	}

	kID, ok := item.FindStringKey(msg.Field)
	if !ok {
		return errInternal(errors.New("field provided does not existing within the item"))
	}

	item.Strings[kID].Value = msg.Value

	if err := keeper.SetItem(ctx, item); err != nil {
		return errInternal(errors.New("error updating item inside keeper"))
	}

	return marshalJson(CheckExecutionResp{
		Message: "successfully updated the item field",
		Status:  "Success",
	})
}

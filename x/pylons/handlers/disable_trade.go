package handlers

import (
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// DisableTradeResponse is the response for enableTrade
type DisableTradeResponse struct {
	Message string
	Status  string
}

// HandlerMsgDisableTrade is used to enable trade by a developer
func HandlerMsgDisableTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgDisableTrade) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	trade, err := keeper.GetTrade(ctx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if !msg.Sender.Equals(trade.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Trade initiator is not the same as sender")
	}

	if trade.Completed && (trade.FulFiller != nil) {
		return nil, errInternal(errors.New("Cannot disable a completed trade"))
	}

	trade.Disabled = true

	// unset items' owner trade id
	for idx, item := range trade.ItemOutputs {
		itemFromStore, err := keeper.GetItem(ctx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}

		if !itemFromStore.Sender.Equals(trade.Sender) {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", itemFromStore.ID))
		}

		itemFromStore.OwnerTradeID = ""
		err = keeper.SetItem(ctx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
		trade.ItemOutputs[idx] = itemFromStore
	}

	err = keeper.UpdateTrade(ctx, msg.TradeID, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(DisableTradeResponse{
		Message: "successfully disabled the trade",
		Status:  "Success",
	})
}

package handlers

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// EnableTradeResponse is the response for enableTrade
type EnableTradeResponse struct {
	Message string
	Status  string
}

// HandlerMsgEnableTrade is used to enable trade by a developer
func HandlerMsgEnableTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgEnableTrade) (*sdk.Result, error) {

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

	trade.Disabled = false

	// reset items' owner trade id
	for idx, item := range trade.ItemOutputs {
		itemFromStore, err := keeper.GetItem(ctx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}

		if !itemFromStore.Sender.Equals(trade.Sender) {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", itemFromStore.ID))
		}

		if err = itemFromStore.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", itemFromStore.ID))
		}
		itemFromStore.OwnerTradeID = trade.ID
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

	err = keeper.LockCoin(ctx, types.NewLockedCoin(trade.Sender, trade.CoinOutputs))

	if err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(EnableTradeResponse{
		Message: "successfully enabled the trade",
		Status:  "Success",
	})
}

package handlers

import (
	"context"
	"fmt"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgEnableTrade is used to enable trade by a developer
func (k msgServer) HandlerMsgEnableTrade(ctx context.Context, msg *msgs.MsgEnableTrade) (*msgs.MsgEnableTradeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)

	trade, err := k.GetTrade(sdkCtx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if msg.Sender != trade.Sender.String() {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Trade initiator is not the same as sender")
	}

	trade.Disabled = false

	// reset items' owner trade id
	for idx, item := range trade.ItemOutputs.List {
		itemFromStore, err := k.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}

		if itemFromStore.Sender != trade.Sender.String() {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", itemFromStore.ID))
		}

		if err = itemFromStore.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", itemFromStore.ID))
		}
		itemFromStore.OwnerTradeID = trade.ID
		err = k.SetItem(sdkCtx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
		trade.ItemOutputs.List[idx] = &itemFromStore
	}

	err = k.UpdateTrade(sdkCtx, msg.TradeID, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	err = k.LockCoin(sdkCtx, types.NewLockedCoin(trade.Sender, trade.CoinOutputs))

	if err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgEnableTradeResponse{
		Message: "successfully enabled the trade",
		Status:  "Success",
	}, nil
}

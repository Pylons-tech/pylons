package handlers

import (
	"context"
	"errors"
	"fmt"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// DisableTrade is used to enable trade by a developer
func (k msgServer) DisableTrade(ctx context.Context, msg *msgs.MsgDisableTrade) (*msgs.MsgDisableTradeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)

	trade, err := k.GetTrade(sdkCtx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if msg.Sender != trade.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Trade initiator is not the same as sender")
	}

	if trade.Completed && (trade.FulFiller != "") {
		return nil, errInternal(errors.New("Cannot disable a completed trade"))
	}

	trade.Disabled = true

	// unset items' owner trade id
	for idx, item := range trade.ItemOutputs.List {
		itemFromStore, err := k.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}

		if itemFromStore.Sender != trade.Sender {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", itemFromStore.ID))
		}

		itemFromStore.OwnerTradeID = ""
		err = k.SetItem(sdkCtx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
		trade.ItemOutputs.List[idx] = itemFromStore
	}

	err = k.UpdateTrade(sdkCtx, msg.TradeID, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	sender, err := sdk.AccAddressFromBech32(trade.Sender)
	if err != nil {
		return nil, errInternal(err)
	}
	err = k.UnlockCoin(sdkCtx, types.NewLockedCoin(sender, trade.CoinOutputs))
	if err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgDisableTradeResponse{
		Message: "successfully disabled the trade",
		Status:  "Success",
	}, nil
}

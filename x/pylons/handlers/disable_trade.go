package handlers

import (
	"errors"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// DisableTradeResp is the response for enableTrade
type DisableTradeResp struct {
	Message string
	Status  string
}

// HandlerMsgDisableTrade is used to enable trade by a developer
func HandlerMsgDisableTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgDisableTrade) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	trade, err2 := keeper.GetTrade(ctx, msg.TradeID)
	if err2 != nil {
		return errInternal(err2)
	}

	if !msg.Sender.Equals(trade.Sender) {
		return sdk.ErrUnauthorized("Trade initiator is not the same as sender").Result()
	}

	if trade.Completed && (trade.FulFiller != nil) {
		return errInternal(errors.New("Cannot disable a completed trade"))
	}

	trade.Disabled = true

	err2 = keeper.UpdateTrade(ctx, msg.TradeID, trade)
	if err2 != nil {
		return errInternal(err2)
	}

	return marshalJson(DisableTradeResp{
		Message: "successfully disabled the trade",
		Status:  "Success",
	})
}

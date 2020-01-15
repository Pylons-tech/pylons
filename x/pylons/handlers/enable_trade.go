package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// EnableTradeResp is the response for enableTrade
type EnableTradeResp struct {
	Message string
	Status  string
}

// HandlerMsgEnableTrade is used to enable trade by a developer
func HandlerMsgEnableTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgEnableTrade) sdk.Result {

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

	trade.Disabled = false

	err2 = keeper.UpdateTrade(ctx, msg.TradeID, trade)
	if err2 != nil {
		return errInternal(err2)
	}

	return marshalJson(EnableTradeResp{
		Message: "successfully enabled the trade",
		Status:  "Success",
	})
}

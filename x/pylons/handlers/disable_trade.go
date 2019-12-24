package handlers

import (
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
		return sdk.ErrUnauthorized("msg sender is not the owner of the trade").Result()
	}

	trade.Disabled = false

	err2 = keeper.UpdateTrade(ctx, msg.TradeID, trade)
	if err2 != nil {
		return errInternal(err2)
	}

	return marshalJson(DisableTradeResp{
		Message: "successfully enabled the trade",
		Status:  "Success",
	})
}

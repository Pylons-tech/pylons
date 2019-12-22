package handlers

import (
	"errors"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// DeleteTradeResponse is the response returned by DeleteTrade Handler
type DeleteTradeResponse struct {
	Status  string `json:"Status"`
	Message string `json:"Message"`
}

// HandlerMsgDeleteTrade is used to create a trade by a user
func HandlerMsgDeleteTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgDeleteTrade) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	trade, err2 := keeper.GetTrade(ctx, msg.TradeID)

	if err2 != nil {
		return errInternal(err2)
	}

	if !trade.Sender.Equals(msg.Sender) {
		return sdk.ErrUnauthorized("Trade initiator is not the same as sender").Result()
	}

	if trade.Completed && (trade.FulFiller != nil) {
		return errInternal(errors.New("Cannot delete a completed trade"))
	}

	keeper.DeleteTrade(ctx, msg.TradeID)

	return marshalJson(DeleteTradeResponse{
		"Success",
		"Deleted the trade successfully",
	})
}

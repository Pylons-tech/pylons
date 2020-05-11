package handlers

import (
	"math/rand"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// DisableTradeResp is the response for enableTrade
type DisableTradeResp struct {
	Message string
	Status  string
}

// HandlerMsgDisableTrade is used to enable trade by a developer
func HandlerMsgDisableTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgDisableTrade) (*sdk.Result, error) {
	// set random seed at the start point of handler
	rand.Seed(types.RandomSeed(ctx))
	
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	trade, err2 := keeper.GetTrade(ctx, msg.TradeID)
	if err2 != nil {
		return nil, errInternal(err2)
	}

	if !msg.Sender.Equals(trade.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Trade initiator is not the same as sender")
	}

	if trade.Completed && (trade.FulFiller != nil) {
		return nil, errInternal(errors.New("Cannot disable a completed trade"))
	}

	trade.Disabled = true

	err2 = keeper.UpdateTrade(ctx, msg.TradeID, trade)
	if err2 != nil {
		return nil, errInternal(err2)
	}

	return marshalJson(DisableTradeResp{
		Message: "successfully disabled the trade",
		Status:  "Success",
	})
}

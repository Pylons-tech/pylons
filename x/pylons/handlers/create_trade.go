package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CreateTradeResponse struct {
	TradeID string `json:"TradeID"`
}

// HandlerMsgCreateTrade is used to create cookbook by a developer
func HandlerMsgCreateTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateTrade) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	trade := types.NewTradeRecipe(msg.TradeName, msg.Description,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.Entries,
		msg.Sender)
	if err := keeper.SetRecipe(ctx, trade); err != nil {
		return sdk.ErrInternal(err.Error()).Result()
	}

	mTrade, err2 := json.Marshal(map[string]string{
		"TradeID": trade.ID,
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	return sdk.Result{Data: mTrade}
}

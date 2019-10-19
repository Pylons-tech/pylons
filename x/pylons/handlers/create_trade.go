package handlers

import (
	"encoding/json"
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CreateTradeResponse struct {
	TradeID string `json:"TradeID"`
}

// HandlerMsgCreateTrade is used to create a trade by a user
func HandlerMsgCreateTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateTrade) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	for _, item := range msg.ItemOutputs {
		itemFromStore, err := keeper.GetItem(ctx, item.ID)
		if err != nil {
			return sdk.ErrInternal(err.Error()).Result()
		}
		if !itemFromStore.Sender.Equals(msg.Sender) {
			return sdk.ErrUnauthorized(fmt.Sprintf("item with %s id is not owned by sender", item.ID)).Result()
		}
	}

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, msg.CoinOutputs) {
		return sdk.ErrInsufficientCoins("sender doesn't have enough coins for the trade").Result()
	}

	trade := types.NewTrade(msg.Name, msg.ExtraInfo,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.CoinOutputs,
		msg.ItemOutputs,
		msg.Sender)
	if err := keeper.SetTrade(ctx, trade); err != nil {
		return sdk.ErrInternal(err.Error()).Result()
	}

	mTrade, err2 := json.Marshal(CreateTradeResponse{
		trade.ID,
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	return sdk.Result{Data: mTrade}
}

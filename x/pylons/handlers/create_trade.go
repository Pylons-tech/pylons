package handlers

import (
	"math/rand"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

type CreateTradeResponse struct {
	TradeID string `json:"TradeID"`
}

// HandlerMsgCreateTrade is used to create a trade by a user
func HandlerMsgCreateTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateTrade) (*sdk.Result, error) {
	// set random seed at the start point of handler
	rand.Seed(types.RandomSeed(ctx))
	
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	for _, item := range msg.ItemOutputs {
		itemFromStore, err := keeper.GetItem(ctx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}
		if !itemFromStore.Sender.Equals(msg.Sender) {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("item with %s id is not owned by sender", item.ID))
		}
		if !itemFromStore.Tradable {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", itemFromStore.ID))
		}
	}

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, msg.CoinOutputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "sender doesn't have enough coins for the trade")
	}

	trade := types.NewTrade(msg.ExtraInfo,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.CoinOutputs,
		msg.ItemOutputs,
		msg.Sender)
	if err := keeper.SetTrade(ctx, trade); err != nil {
		return nil, errInternal(err)
	}

	return marshalJson(CreateTradeResponse{
		trade.ID,
	})
}

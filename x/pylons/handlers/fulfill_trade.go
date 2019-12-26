package handlers

import (
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// FulfillTradeResp is the response for fulfillRecipe
type FulfillTradeResp struct {
	Message string
	Status  string
}

// HandlerMsgFulfillTrade is used to fulfill a trade
func HandlerMsgFulfillTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgFulfillTrade) sdk.Result {
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	trade, err2 := keeper.GetTrade(ctx, msg.TradeID)
	if err2 != nil {
		return errInternal(err2)
	}

	if trade.Completed {
		return sdk.ErrInternal("this trade is already completed").Result()

	}

	items, err2 := keeper.GetItemsBySender(ctx, msg.Sender)
	if err2 != nil {
		return errInternal(err2)
	}

	// check if the sender has all condition met

	matchedItems := types.ItemList{}
	for _, inpItem := range trade.ItemInputs {
		matched := false
		index := 0
		for i, item := range items {
			if item.MatchItemInput(inpItem) {
				matched = true
				index = i
				break
			}
		}
		if matched {
			matchedItem := items[index]
			if !matchedItem.Tradable {
				return errInternal(fmt.Errorf("%s item id is not tradable", matchedItem.ID))
			}
			matchedItems = append(matchedItems, matchedItem)
		} else {
			return sdk.ErrInternal(fmt.Sprintf("the sender doesn't have the trade item attributes %+v", inpItem)).Result()
		}
	}

	inputCoins := trade.CoinInputs.ToCoins()
	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, inputCoins) {
		return sdk.ErrInsufficientCoins("the sender doesn't have sufficient coins").Result()
	}

	if !keeper.CoinKeeper.HasCoins(ctx, trade.Sender, trade.CoinOutputs) {
		return sdk.ErrInsufficientCoins("the trade creator doesn't have sufficient coins").Result()
	}

	// -------------------- handle Item interactions ----------------

	refreshedOutputItems := types.ItemList{}

	// get the items from the trade initiator
	for _, item := range trade.ItemOutputs {
		// verify if its still owned by the initiator
		storedItem, err := keeper.GetItem(ctx, item.ID)
		if err != nil {
			return errInternal(err)
		}
		// if it isn't then we error out as there hasn't been any state changes so far
		if !storedItem.Sender.Equals(trade.Sender) {
			return sdk.ErrUnauthorized(fmt.Sprintf("Item with id %s is not owned by the trade creator", storedItem.ID)).Result()
		}

		if !storedItem.Tradable {
			return errInternal(fmt.Errorf("%s item id is not tradable", storedItem.ID))
		}

		refreshedOutputItems = append(refreshedOutputItems, storedItem)
	}

	for _, item := range refreshedOutputItems {
		item.Sender = msg.Sender
		err := keeper.SetItem(ctx, item)
		if err != nil {
			return errInternal(err2)
		}
	}

	for _, item := range matchedItems {
		item.Sender = trade.Sender
		err := keeper.SetItem(ctx, item)
		if err != nil {
			return errInternal(err2)
		}
	}

	// ----------------- handle coin interaction ----------------------

	// trade creator to trade acceptor the coin output
	_, err = keeper.CoinKeeper.SendCoins(ctx, trade.Sender, msg.Sender, trade.CoinOutputs)

	if err != nil {
		return errInternal(err2)
	}

	// trade acceptor to trade creator the coin input
	_, err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, trade.Sender, inputCoins)

	if err != nil {
		return errInternal(err2)
	}

	trade.FulFiller = msg.Sender
	trade.Completed = true
	err2 = keeper.SetTrade(ctx, trade)
	if err != nil {
		return errInternal(err2)
	}

	return marshalJson(FulfillTradeResp{
		Message: "successfully fulfilled the trade",
		Status:  "Success",
	})
}

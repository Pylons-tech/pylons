package handlers

import (
	"math/rand"
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// FulfillTradeResp is the response for fulfillRecipe
type FulfillTradeResp struct {
	Message string
	Status  string
}

// HandlerMsgFulfillTrade is used to fulfill a trade
func HandlerMsgFulfillTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgFulfillTrade) (*sdk.Result, error) {
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

	if trade.Completed {
		return nil, errInternal(errors.New("this trade is already completed"))

	}

	items, err2 := keeper.GetItemsBySender(ctx, msg.Sender)
	if err2 != nil {
		return nil, errInternal(err2)
	}

	// check if the sender has all condition met

	matchedItems := types.ItemList{}
	for _, inpItem := range trade.ItemInputs {
		matched := false
		index := 0
		for i, item := range items {
			if inpItem.Matches(item) {
				matched = true
				index = i
				break
			}
		}
		if matched {
			matchedItem := items[index]
			if !matchedItem.Tradable {
				return nil, errInternal(fmt.Errorf("%s item id is not tradable", matchedItem.ID))
			}
			matchedItems = append(matchedItems, matchedItem)
		} else {
			return nil, errInternal(errors.New(fmt.Sprintf("the sender doesn't have the trade item attributes %+v", inpItem)))
		}
	}

	inputCoins := trade.CoinInputs.ToCoins()
	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, inputCoins) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the sender doesn't have sufficient coins")
	}

	if !keeper.CoinKeeper.HasCoins(ctx, trade.Sender, trade.CoinOutputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the trade creator doesn't have sufficient coins")
	}

	// -------------------- handle Item interactions ----------------

	refreshedOutputItems := types.ItemList{}

	// get the items from the trade initiator
	for _, item := range trade.ItemOutputs {
		// verify if its still owned by the initiator
		storedItem, err := keeper.GetItem(ctx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}
		// if it isn't then we error out as there hasn't been any state changes so far
		if !storedItem.Sender.Equals(trade.Sender) {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", storedItem.ID))
		}

		if !storedItem.Tradable {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", storedItem.ID))
		}

		refreshedOutputItems = append(refreshedOutputItems, storedItem)
	}

	for _, item := range refreshedOutputItems {
		item.Sender = msg.Sender
		err := keeper.SetItem(ctx, item)
		if err != nil {
			return nil, errInternal(err2)
		}
	}

	for _, item := range matchedItems {
		item.Sender = trade.Sender
		err := keeper.SetItem(ctx, item)
		if err != nil {
			return nil, errInternal(err2)
		}
	}

	// ----------------- handle coin interaction ----------------------

	// trade creator to trade acceptor the coin output
	err = keeper.CoinKeeper.SendCoins(ctx, trade.Sender, msg.Sender, trade.CoinOutputs)

	if err != nil {
		return nil, errInternal(err2)
	}

	// trade acceptor to trade creator the coin input
	err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, trade.Sender, inputCoins)

	if err != nil {
		return nil, errInternal(err2)
	}

	trade.FulFiller = msg.Sender
	trade.Completed = true
	err2 = keeper.SetTrade(ctx, trade)
	if err != nil {
		return nil, errInternal(err2)
	}

	return marshalJson(FulfillTradeResp{
		Message: "successfully fulfilled the trade",
		Status:  "Success",
	})
}

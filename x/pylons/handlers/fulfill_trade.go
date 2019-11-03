package handlers

import (
	"encoding/json"
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
	Output  []byte
}

// HandlerMsgFulfillTrade is used to fulfill a trade
func HandlerMsgFulfillTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgFulfillTrade) sdk.Result {
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	trade, err2 := keeper.GetTrade(ctx, msg.TradeID)
	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	items, err2 := keeper.GetItemsBySender(ctx, msg.Sender)
	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
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
			matchedItems = append(matchedItems, items[index])
		} else {
			return sdk.ErrInternal(fmt.Sprintf("the sender doesn't have the trade item attributes %+v", inpItem)).Result()
		}
	}

	refreshedOutputItems := types.ItemList{}

	// -------------------- handle Item interactions ----------------

	// get the items from the trade initiator
	for _, item := range trade.ItemOutputs {
		// verify if its still owned by the initiator
		storedItem, err := keeper.GetItem(ctx, item.ID)
		if err != nil {
			return sdk.ErrInternal(err.Error()).Result()
		}
		// if it isn't then we error out as there hasn't been any state changes so far
		if !storedItem.Sender.Equals(trade.Sender) {
			return sdk.ErrUnauthorized(fmt.Sprintf("Item with id %s is not owned by the trade creator", storedItem.ID)).Result()
		}

		refreshedOutputItems = append(refreshedOutputItems, storedItem)
	}

	// TODO: implement rollback strategy
	for _, item := range refreshedOutputItems {
		item.Sender = msg.Sender
		// TODO: implement rollback strategy here
		err := keeper.SetItem(ctx, item)
		if err != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}
	}

	for _, item := range matchedItems {
		item.Sender = trade.Sender
		// TODO: implement rollback strategy here
		err := keeper.SetItem(ctx, item)
		if err != nil {
			return sdk.ErrInternal(err2.Error()).Result()
		}
	}

	// ----------------- handle coin interaction ----------------------

	// TODO: coin interactions

	resp, err3 := json.Marshal(FulfillTradeResp{
		Message: "successfully fulfilled the trade",
		Status:  "Success",
	})

	if err3 != nil {
		return sdk.ErrInternal(err3.Error()).Result()
	}

	return sdk.Result{Data: resp}
}

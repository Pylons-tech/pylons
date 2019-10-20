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

	// TODO: exchange items

	resp, err3 := json.Marshal(FulfillTradeResp{
		Message: "successfully fulfilled the trade",
		Status:  "Success",
	})

	if err3 != nil {
		return sdk.ErrInternal(err3.Error()).Result()
	}

	return sdk.Result{Data: resp}
}

package handlers

import (
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// FulfillTradeResponse is the response for fulfillRecipe
type FulfillTradeResponse struct {
	Message string
	Status  string
}

// HandlerMsgFulfillTrade is used to fulfill a trade
func HandlerMsgFulfillTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgFulfillTrade) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	trade, err := keeper.GetTrade(ctx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if trade.Completed {
		return nil, errInternal(errors.New("this trade is already completed"))
	}

	if len(msg.ItemIDs) != len(trade.ItemInputs) {
		return nil, errInternal(errors.New("the item IDs count doesn't match the trade input"))
	}

	items, err := GetItemsFromIDs(ctx, keeper, msg.ItemIDs, msg.Sender)
	if err != nil {
		return nil, errInternal(err)
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
			if err = matchedItem.NewTradeError(); err != nil {
				return nil, errInternal(fmt.Errorf("%s item id is not tradable", matchedItem.ID))
			}
			matchedItems = append(matchedItems, matchedItem)
		} else {
			return nil, errInternal(fmt.Errorf("the sender doesn't have the trade item attributes %+v", inpItem))
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

		if err = storedItem.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", storedItem.ID))
		}

		refreshedOutputItems = append(refreshedOutputItems, storedItem)
	}

	for _, item := range refreshedOutputItems {
		item.Sender = msg.Sender
		err := keeper.SetItem(ctx, item)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	for _, item := range matchedItems {
		item.Sender = trade.Sender
		err := keeper.SetItem(ctx, item)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	// ----------------- handle coin interaction ----------------------

	// trade creator to trade acceptor the coin output
	err = keeper.CoinKeeper.SendCoins(ctx, trade.Sender, msg.Sender, trade.CoinOutputs)
	if err != nil {
		return nil, errInternal(err)
	}
	err = ProcessCoinIncomeFee(ctx, keeper, msg.Sender, trade.CoinOutputs)
	if err != nil {
		return nil, errInternal(err)
	}

	// trade acceptor to trade creator the coin input
	err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, trade.Sender, inputCoins)
	if err != nil {
		return nil, errInternal(err)
	}
	err = ProcessCoinIncomeFee(ctx, keeper, trade.Sender, inputCoins)
	if err != nil {
		return nil, errInternal(err)
	}

	trade.FulFiller = msg.Sender
	trade.Completed = true
	err = keeper.SetTrade(ctx, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(FulfillTradeResponse{
		Message: "successfully fulfilled the trade",
		Status:  "Success",
	})
}

// ProcessCoinIncomeFee process trading accepter fee
func ProcessCoinIncomeFee(ctx sdk.Context, keeper keep.Keeper, Sender sdk.AccAddress, coins sdk.Coins) error {
	// send pylon amount to PylonsLLC, validator
	pylonAmount := coins.AmountOf(types.Pylon).Int64()
	if pylonAmount > 0 {
		tradePercent := config.Config.Fee.PylonsTradePercent
		pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			return err
		}
		pylonsLLCAmount := Max(1, pylonAmount*tradePercent/100)
		return keeper.CoinKeeper.SendCoins(ctx, Sender, pylonsLLCAddress, types.NewPylon(pylonsLLCAmount))
	}
	return nil
}

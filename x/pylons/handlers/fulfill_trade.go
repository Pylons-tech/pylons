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

	// get pylons LLC address
	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	if err != nil {
		return nil, errInternal(err)
	}

	// check if the sender has all condition met

	totalItemTransferFee := int64(0)

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
			totalItemTransferFee += matchedItem.GetTransferFee()
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

		if err = storedItem.FulfillTradeError(trade.ID); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", storedItem.ID))
		}

		totalItemTransferFee += storedItem.GetTransferFee()

		refreshedOutputItems = append(refreshedOutputItems, storedItem)
	}

	inputPylonsAmount := inputCoins.AmountOf(types.Pylon)
	outputPylonsAmount := trade.CoinOutputs.AmountOf(types.Pylon)
	totalPylonsAmount := inputPylonsAmount.Int64() + outputPylonsAmount.Int64()

	// Select bigger one between total additional fee and total pylons amount
	tradePercent := config.Config.Fee.PylonsTradePercent
	totalPylonsAmountFee := totalPylonsAmount * tradePercent / 100

	totalFee := Max(totalItemTransferFee, totalPylonsAmountFee)
	// if total fee exceeds the total pylons amount, it fails
	if totalFee > totalPylonsAmount {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "total pylons amount is not enough to pay fees")
	}

	// divide total fee between the sender and fullfiller

	if totalPylonsAmount == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "totalPylonsAmount is 0 unexpectedly")
	}
	senderFee := totalFee * outputPylonsAmount.Int64() / totalPylonsAmount

	if senderFee != 0 {
		err = keeper.CoinKeeper.SendCoins(ctx, trade.Sender, pylonsLLCAddress, types.NewPylon(senderFee))
		if err != nil {
			return nil, errInternal(err)
		}
	}

	fulfillerFee := totalFee - senderFee

	if fulfillerFee != 0 {
		err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, pylonsLLCAddress, types.NewPylon(fulfillerFee))
		if err != nil {
			return nil, errInternal(err)
		}
	}

	totalFeeForCBOwners := totalFee * config.Config.Fee.CbSenderItemTransferPercent / 100

	for _, item := range refreshedOutputItems {

		if totalItemTransferFee == 0 {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "totalItemTransferFee is 0 unexpectedly")
		}
		feeForCB := totalFeeForCBOwners * item.GetTransferFee() / totalItemTransferFee

		cookbook, err := keeper.GetCookbook(ctx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("Invalid cookbook id"))
		}

		if feeForCB > 0 {
			err = keeper.CoinKeeper.SendCoins(ctx, pylonsLLCAddress, cookbook.Sender, types.NewPylon(feeForCB))
			if err != nil {
				return nil, errInternal(err)
			}
		}

		item.Sender = msg.Sender
		item.OwnerTradeID = ""
		err = keeper.SetItem(ctx, item)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	for _, item := range matchedItems {
		if totalItemTransferFee == 0 {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "totalItemTransferFee is 0 unexpectedly")
		}
		feeForCB := totalFeeForCBOwners * item.GetTransferFee() / totalItemTransferFee

		cookbook, err := keeper.GetCookbook(ctx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("Invalid cookbook id"))
		}

		if feeForCB > 0 {
			err = keeper.CoinKeeper.SendCoins(ctx, pylonsLLCAddress, cookbook.Sender, types.NewPylon(feeForCB))
			if err != nil {
				return nil, errInternal(err)
			}
		}

		item.Sender = trade.Sender
		err = keeper.SetItem(ctx, item)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	// ----------------- handle coin interaction ----------------------

	// trade creator to trade acceptor the coin output
	// Send output coin from sender to fullfiller
	restOutputPylon := types.NewPylon(trade.CoinOutputs.AmountOf(types.Pylon).Int64() - senderFee)

	if restOutputPylon.AmountOf(types.Pylon).Int64() > 0 {
		err = keeper.CoinKeeper.SendCoins(ctx, trade.Sender, msg.Sender, restOutputPylon)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	// trade acceptor to trade creator the coin input
	// Send input coin from fullfiller to sender (trade creator)
	restInputPylon := types.NewPylon(inputCoins.AmountOf(types.Pylon).Int64() - fulfillerFee)

	if restInputPylon.AmountOf(types.Pylon).Int64() > 0 {
		err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, trade.Sender, restInputPylon)
		if err != nil {
			return nil, errInternal(err)
		}
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

package handlers

import (
	"context"
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// FulfillTrade is used to fulfill a trade
func (k msgServer) FulfillTrade(ctx context.Context, msg *msgs.MsgFulfillTrade) (*msgs.MsgFulfillTradeResponse, error) {
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	trade, err := k.GetTrade(sdkCtx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if trade.Completed {
		return nil, errInternal(errors.New("this trade is already completed"))
	}

	if len(msg.ItemIDs) != len(trade.ItemInputs.List) {
		return nil, errInternal(errors.New("the item IDs count doesn't match the trade input"))
	}

	items, err := GetItemsFromIDs(sdkCtx, k.Keeper, msg.ItemIDs, sender)
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
	for i, itemInput := range trade.ItemInputs.List {
		matchedItem := items[i]
		ec, err := keeper.EnvCollection(ctx, "", msg.TradeID, matchedItem)
		if err != nil {
			return nil, errInternal(fmt.Errorf("error creating env collection for %s item", matchedItem.String()))
		}
		matchErr := itemInput.MatchError(matchedItem, ec)
		if matchErr != nil {
			return nil, errInternal(fmt.Errorf("[%d]th item does not match: %s item_id=%s", i, matchErr.Error(), matchedItem.ID))
		}
		if err = matchedItem.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("[%d]th item is not tradable: %s item_id=%s", i, err.Error(), matchedItem.ID))
		}
		totalItemTransferFee += matchedItem.GetTransferFee()
		matchedItems.List = append(matchedItems.List, matchedItem)
	}
	tradeSender, err := sdk.AccAddressFromBech32(trade.Sender)
	if err != nil {
		return nil, errInternal(err)
	}
	// Unlock trade creator's coins
	err = k.UnlockCoin(sdkCtx, types.NewLockedCoin(tradeSender, trade.CoinOutputs))
	if err != nil {
		return nil, errInternal(err)
	}

	inputCoins := trade.CoinInputs.ToCoins()
	if !keep.HasCoins(k.Keeper, sdkCtx, sender, inputCoins) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the sender doesn't have sufficient coins")
	}

	if !keep.HasCoins(k.Keeper, sdkCtx, tradeSender, trade.CoinOutputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the trade creator doesn't have sufficient coins")
	}

	// -------------------- handle Item interactions ----------------
	refreshedOutputItems := types.ItemList{}

	// get the items from the trade initiator
	for _, item := range trade.ItemOutputs.List {
		// verify if its still owned by the initiator
		storedItem, err := k.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}
		// if it isn't then we error out as there hasn't been any state changes so far
		if storedItem.Sender != trade.Sender {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", storedItem.ID))
		}

		if err = storedItem.FulfillTradeError(trade.ID); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", storedItem.ID))
		}

		totalItemTransferFee += storedItem.GetTransferFee()

		refreshedOutputItems.List = append(refreshedOutputItems.List, storedItem)
	}

	// ----------------- handle coin interaction ----------------------
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

	// trade creator to trade acceptor the coin output
	// Send output coin from sender to fullfiller

	err = keep.SendCoins(k.Keeper, sdkCtx, tradeSender, sender, trade.CoinOutputs)

	if err != nil {
		return nil, errInternal(err)
	}
	senderFee := totalFee * outputPylonsAmount.Int64() / totalPylonsAmount
	if senderFee != 0 {
		// sender process fee after receiving coins from trade.Sender
		err = keep.SendCoins(k.Keeper, sdkCtx, sender, pylonsLLCAddress, types.NewPylon(senderFee))
		if err != nil {
			return nil, errInternal(err)
		}
	}

	// trade acceptor to trade creator the coin input
	// Send input coin from fullfiller to sender (trade creator)
	err = keep.SendCoins(k.Keeper, sdkCtx, sender, tradeSender, inputCoins)
	if err != nil {
		return nil, errInternal(err)
	}
	fulfillerFee := totalFee - senderFee
	if fulfillerFee != 0 {
		// trade.Sender process fee after receiving coins from sender
		err = keep.SendCoins(k.Keeper, sdkCtx, tradeSender, pylonsLLCAddress, types.NewPylon(fulfillerFee))
		if err != nil {
			return nil, errInternal(err)
		}
	}

	totalFeeForCBOwners := totalFee * config.Config.Fee.ItemTransferCookbookOwnerProfitPercent / 100

	for _, item := range refreshedOutputItems.List {

		if totalItemTransferFee == 0 {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "totalItemTransferFee is 0 unexpectedly")
		}
		feeForCB := totalFeeForCBOwners * item.GetTransferFee() / totalItemTransferFee

		cookbook, err := k.GetCookbook(sdkCtx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("Invalid cookbook id"))
		}

		if feeForCB > 0 {
			err = keep.SendCoins(k.Keeper, sdkCtx, pylonsLLCAddress, cookbook.Sender, types.NewPylon(feeForCB))
			if err != nil {
				return nil, errInternal(err)
			}
		}

		item.Sender = sender.String()

		k.SetItemHistory(ctx, types.ItemHistory{
			ID:      types.KeyGen(item.Sender),
			Owner:   item.Sender,
			ItemID:  item.ID,
			TradeID: item.OwnerTradeID,
		})

		item.OwnerTradeID = ""
		err = k.SetItem(sdkCtx, item)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	for _, item := range matchedItems.List {
		if totalItemTransferFee == 0 {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "totalItemTransferFee is 0 unexpectedly")
		}
		feeForCB := totalFeeForCBOwners * item.GetTransferFee() / totalItemTransferFee

		cookbook, err := k.GetCookbook(sdkCtx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("Invalid cookbook id"))
		}

		if feeForCB > 0 {
			err = keep.SendCoins(k.Keeper, sdkCtx, pylonsLLCAddress, cookbook.Sender, types.NewPylon(feeForCB))
			if err != nil {
				return nil, errInternal(err)
			}
		}

		item.Sender = trade.Sender
		err = k.SetItem(sdkCtx, item)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	trade.FulFiller = sender.String()
	trade.Completed = true
	err = k.SetTrade(sdkCtx, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgFulfillTradeResponse{
		Message: "successfully fulfilled the trade",
		Status:  "Success",
	}, nil
}

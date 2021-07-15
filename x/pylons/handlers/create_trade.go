package handlers

import (
	"context"
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CreateTrade is used to create a trade by a user
func (srv msgServer) CreateTrade(ctx context.Context, msg *types.MsgCreateTrade) (*types.MsgCreateTradeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	for _, tii := range msg.ItemInputs {
		_, err := srv.GetCookbook(sdkCtx, tii.CookbookID)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("You specified a cookbook that does not exist where raw error is %+v", err))
		}
	}

	for _, item := range msg.ItemOutputs {
		itemFromStore, err := srv.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}
		if itemFromStore.Sender != msg.Sender {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("item with %s id is not owned by sender", item.ID))
		}
		if err = itemFromStore.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", itemFromStore.ID))
		}
	}

	if !keeper.HasCoins(srv.Keeper, sdkCtx, sender, msg.CoinOutputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "sender doesn't have enough coins for the trade")
	}

	err = srv.LockCoin(sdkCtx, types.NewLockedCoin(sender, msg.CoinOutputs))

	if err != nil {
		return nil, errInternal(err)
	}

	trade := types.NewTrade(msg.ExtraInfo,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.CoinOutputs,
		msg.ItemOutputs,
		sender)
	if err := srv.SetTrade(sdkCtx, trade); err != nil {
		return nil, errInternal(err)
	}

	// set items' owner trade id
	for _, item := range msg.ItemOutputs {
		itemFromStore, err := srv.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}
		itemFromStore.OwnerTradeID = trade.ID
		err = srv.SetItem(sdkCtx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	return &types.MsgCreateTradeResponse{
		TradeID: trade.ID,
		Message: "successfully created a trade",
		Status:  "Success",
	}, nil
}

// FulfillTrade is used to fulfill a trade
func (srv msgServer) FulfillTrade(ctx context.Context, msg *types.MsgFulfillTrade) (*types.MsgFulfillTradeResponse, error) {
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	trade, err := srv.GetTrade(sdkCtx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if trade.Completed {
		return nil, errInternal(errors.New("this trade is already completed"))
	}

	if len(msg.ItemIDs) != len(trade.ItemInputs) {
		return nil, errInternal(errors.New("the item IDs count doesn't match the trade input"))
	}

	items, err := GetItemsFromIDs(sdkCtx, srv.Keeper, msg.ItemIDs, sender)
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
	for i, itemInput := range trade.ItemInputs {
		matchedItem := items[i]
		ec, err := srv.EnvCollection(sdkCtx, "", msg.TradeID, matchedItem)
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
		totalItemTransferFee += matchedItem.CalculateTransferFee()
		matchedItems = append(matchedItems, matchedItem)
	}
	tradeSender, err := sdk.AccAddressFromBech32(trade.Sender)
	if err != nil {
		return nil, errInternal(err)
	}
	// Unlock trade creator's coins
	err = srv.UnlockCoin(sdkCtx, types.NewLockedCoin(tradeSender, trade.CoinOutputs))
	if err != nil {
		return nil, errInternal(err)
	}

	inputCoins := types.CoinInputList(trade.CoinInputs).ToCoins()
	if !keeper.HasCoins(srv.Keeper, sdkCtx, sender, inputCoins) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the sender doesn't have sufficient coins")
	}

	if !keeper.HasCoins(srv.Keeper, sdkCtx, tradeSender, trade.CoinOutputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the trade creator doesn't have sufficient coins")
	}

	// -------------------- handle Item interactions ----------------
	refreshedOutputItems := types.ItemList{}

	// get the items from the trade initiator
	for _, item := range trade.ItemOutputs {
		// verify if its still owned by the initiator
		storedItem, err := srv.GetItem(sdkCtx, item.ID)
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

		totalItemTransferFee += storedItem.CalculateTransferFee()

		refreshedOutputItems = append(refreshedOutputItems, storedItem)
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

	err = keeper.SendCoins(srv.Keeper, sdkCtx, tradeSender, sender, trade.CoinOutputs)

	if err != nil {
		return nil, errInternal(err)
	}
	senderFee := totalFee * outputPylonsAmount.Int64() / totalPylonsAmount
	if senderFee != 0 {
		// sender process fee after receiving coins from trade.Sender
		err = keeper.SendCoins(srv.Keeper, sdkCtx, sender, pylonsLLCAddress, types.NewPylon(senderFee))
		if err != nil {
			return nil, errInternal(err)
		}
	}

	// trade acceptor to trade creator the coin input
	// Send input coin from fullfiller to sender (trade creator)
	err = keeper.SendCoins(srv.Keeper, sdkCtx, sender, tradeSender, inputCoins)
	if err != nil {
		return nil, errInternal(err)
	}
	fulfillerFee := totalFee - senderFee
	if fulfillerFee != 0 {
		// trade.Sender process fee after receiving coins from sender
		err = keeper.SendCoins(srv.Keeper, sdkCtx, tradeSender, pylonsLLCAddress, types.NewPylon(fulfillerFee))
		if err != nil {
			return nil, errInternal(err)
		}
	}

	totalFeeForCBOwners := totalFee * config.Config.Fee.ItemTransferCookbookOwnerProfitPercent / 100

	for _, item := range refreshedOutputItems {

		if totalItemTransferFee == 0 {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "totalItemTransferFee is 0 unexpectedly")
		}
		feeForCB := totalFeeForCBOwners * item.CalculateTransferFee() / totalItemTransferFee

		cookbook, err := srv.GetCookbook(sdkCtx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("invalid cookbook id"))
		}

		cookbookSender, err := sdk.AccAddressFromBech32(cookbook.Sender)
		if err != nil {
			return nil, errInternal(err)
		}

		if feeForCB > 0 {
			err = keeper.SendCoins(srv.Keeper, sdkCtx, pylonsLLCAddress, cookbookSender, types.NewPylon(feeForCB))
			if err != nil {
				return nil, errInternal(err)
			}
		}

		item.Sender = sender.String()

		srv.SetItemHistory(sdkCtx, types.ItemHistory{
			ID:      types.KeyGen(sender),
			Owner:   sender,
			ItemID:  item.ID,
			TradeID: item.OwnerTradeID,
		})

		item.OwnerTradeID = ""
		err = srv.SetItem(sdkCtx, item)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	for _, item := range matchedItems {
		if totalItemTransferFee == 0 {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "totalItemTransferFee is 0 unexpectedly")
		}
		feeForCB := totalFeeForCBOwners * item.CalculateTransferFee() / totalItemTransferFee

		cookbook, err := srv.GetCookbook(sdkCtx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("invalid cookbook id"))
		}

		cookbookSender, err := sdk.AccAddressFromBech32(cookbook.Sender)
		if err != nil {
			return nil, errInternal(err)
		}

		if feeForCB > 0 {
			err = keeper.SendCoins(srv.Keeper, sdkCtx, pylonsLLCAddress, cookbookSender, types.NewPylon(feeForCB))
			if err != nil {
				return nil, errInternal(err)
			}
		}

		item.Sender = trade.Sender
		err = srv.SetItem(sdkCtx, item)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	trade.FulFiller = sender.String()
	trade.Completed = true
	err = srv.SetTrade(sdkCtx, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgFulfillTradeResponse{
		Message: "successfully fulfilled the trade",
		Status:  "Success",
	}, nil
}

// EnableTrade is used to enable trade by a developer
func (srv msgServer) EnableTrade(ctx context.Context, msg *types.MsgEnableTrade) (*types.MsgEnableTradeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)

	trade, err := srv.GetTrade(sdkCtx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if msg.Sender != trade.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Trade initiator is not the same as sender")
	}

	trade.Disabled = false

	// reset items' owner trade id
	for idx, item := range trade.ItemOutputs {
		itemFromStore, err := srv.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}

		if itemFromStore.Sender != trade.Sender {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", itemFromStore.ID))
		}

		if err = itemFromStore.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", itemFromStore.ID))
		}
		itemFromStore.OwnerTradeID = trade.ID
		err = srv.SetItem(sdkCtx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
		trade.ItemOutputs[idx] = itemFromStore
	}

	err = srv.UpdateTrade(sdkCtx, msg.TradeID, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	sender, err := sdk.AccAddressFromBech32(trade.Sender)
	if err != nil {
		return nil, errInternal(err)
	}

	err = srv.LockCoin(sdkCtx, types.NewLockedCoin(sender, trade.CoinOutputs))

	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgEnableTradeResponse{
		Message: "successfully enabled the trade",
		Status:  "Success",
	}, nil
}

// DisableTrade is used to enable trade by a developer
func (srv msgServer) DisableTrade(ctx context.Context, msg *types.MsgDisableTrade) (*types.MsgDisableTradeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)

	trade, err := srv.GetTrade(sdkCtx, msg.TradeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if msg.Sender != trade.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "Trade initiator is not the same as sender")
	}

	if trade.Completed && (trade.FulFiller != "") {
		return nil, errInternal(errors.New("cannot disable a completed trade"))
	}

	trade.Disabled = true

	// unset items' owner trade id
	for idx, item := range trade.ItemOutputs {
		itemFromStore, err := srv.GetItem(sdkCtx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}

		if itemFromStore.Sender != trade.Sender {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("Item with id %s is not owned by the trade creator", itemFromStore.ID))
		}

		itemFromStore.OwnerTradeID = ""
		err = srv.SetItem(sdkCtx, itemFromStore)
		if err != nil {
			return nil, errInternal(err)
		}
		trade.ItemOutputs[idx] = itemFromStore
	}

	err = srv.UpdateTrade(sdkCtx, msg.TradeID, trade)
	if err != nil {
		return nil, errInternal(err)
	}

	sender, err := sdk.AccAddressFromBech32(trade.Sender)
	if err != nil {
		return nil, errInternal(err)
	}
	err = srv.UnlockCoin(sdkCtx, types.NewLockedCoin(sender, trade.CoinOutputs))
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgDisableTradeResponse{
		Message: "successfully disabled the trade",
		Status:  "Success",
	}, nil
}

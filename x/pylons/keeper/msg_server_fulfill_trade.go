package keeper

import (
	"context"
	"strconv"

	"cosmossdk.io/math"
	"github.com/cosmos/cosmos-sdk/telemetry"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) MatchItemInputsForTrade(ctx sdk.Context, creatorAddr string, itemRefs []types.ItemRef, trade types.Trade) ([]types.Item, error) {
	if len(itemRefs) != len(trade.ItemInputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "size mismatch between provided input items and items required by trade")
	}
	matchedInputItems := make([]types.Item, len(trade.ItemInputs))

	// build Item list from inputItemIds
	inputItemMap := make(map[types.ItemRef]types.Item)
	checkedInputItems := make([]bool, len(itemRefs))

	for i, recipeItemInput := range trade.ItemInputs {
		var err error
		for j, itemRef := range itemRefs {
			if checkedInputItems[j] {
				continue
			}
			inputItem, found := inputItemMap[itemRef]
			if !found {
				inputItem, found = k.GetItem(ctx, itemRef.CookbookId, itemRef.ItemId)
				if !found {
					return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v not found", itemRef.ItemId)
				}
				if inputItem.Owner != creatorAddr {
					return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %s not owned by sender", inputItem.Id)
				}
			}
			inputItemMap[itemRef] = inputItem
			// match
			var ec types.CelEnvCollection
			ec, err = k.NewCelEnvCollectionFromItem(ctx, "", strconv.FormatUint(trade.Id, 10), inputItem)
			if err != nil {
				return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			err = recipeItemInput.MatchItem(inputItem, ec)
			if err != nil {
				matchedInputItems[i] = inputItem
				checkedInputItems[j] = true
				break
			}
		}
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot find match for recipe input item ")
		}
	}
	return matchedInputItems, nil
}

func (k msgServer) FulfillTrade(goCtx context.Context, msg *types.MsgFulfillTrade) (*types.MsgFulfillTradeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// get the trade from keeper
	if !k.HasTrade(ctx, msg.Id) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "trade does not exist")
	}
	trade := k.GetTrade(ctx, msg.Id)
	coinInputsIndex := int(msg.CoinInputsIndex)
	var coinInputs sdk.Coins
	// nolint: gocritic
	if coinInputsIndex >= len(trade.CoinInputs) && coinInputsIndex != 0 && len(trade.CoinInputs) != 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid coinInputs index")
	} else if coinInputsIndex == 0 && len(trade.CoinInputs) == 0 {
		coinInputs = sdk.Coins{} // empty coins but valid
	} else {
		coinInputs = trade.CoinInputs[coinInputsIndex].Coins
	}

	addr, _ := sdk.AccAddressFromBech32(msg.Creator)

	// check that coinInputs does not contain an unsendable paymentProcessor coin without a receipt
	err := k.ValidatePaymentInfo(ctx, msg.PaymentInfos, coinInputs)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if len(msg.PaymentInfos) != 0 {
		// client is providing payments receipts
		err := k.ProcessPaymentInfos(ctx, msg.PaymentInfos, addr)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	// check that sender has enough balance to pay coinInputs
	balance := k.bankKeeper.SpendableCoins(ctx, addr)
	if !balance.IsAllGTE(coinInputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "not enough balance to pay for trade coinInputs")
	}

	// match msg items to trade itemInputs
	matchedInputItems, err := k.MatchItemInputsForTrade(ctx, msg.Creator, msg.Items, trade)
	if err != nil {
		return nil, err
	}

	// check coinOutput is GTE amount to pay (from flat fees of itemInputs)
	for _, item := range matchedInputItems {
		if !item.Tradeable {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v cannot be traded", item.Id, item.CookbookId)
		}
	}

	minItemInputsTransferFees := sdk.NewCoins()
	itemInputsTransferFeePermutation, err := types.FindValidPaymentsPermutation(matchedInputItems, trade.CoinOutputs)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot use coinOutputs to pay for the items provided")
	}
	for i := range matchedInputItems {
		minItemInputsTransferFees = minItemInputsTransferFees.Add(matchedInputItems[i].TransferFee[itemInputsTransferFeePermutation[i]])
	}

	outputItems := make([]types.Item, len(trade.ItemOutputs))
	for i, itemRef := range trade.ItemOutputs {
		item, _ := k.GetItem(ctx, itemRef.CookbookId, itemRef.ItemId)
		outputItems[i] = item
	}

	minItemOutputsTransferFees := sdk.NewCoins()
	itemOutputsTransferFeePermutation, err := types.FindValidPaymentsPermutation(outputItems, coinInputs)
	if err != nil {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "coinInputs not sufficient to pay transfer fees")
	}
	for i := range outputItems {
		minItemOutputsTransferFees = minItemOutputsTransferFees.Add(outputItems[i].TransferFee[itemOutputsTransferFeePermutation[i]])
	}

	// calculate item "weights" as a relative percentage of the total sum of items transferFees
	inputItemWeights := make([]math.Int, len(matchedInputItems))
	for i, item := range matchedInputItems {
		transferFee := item.TransferFee[itemInputsTransferFeePermutation[i]]
		weight := transferFee.Amount.Quo(minItemInputsTransferFees.AmountOf(transferFee.Denom))
		inputItemWeights[i] = weight
	}
	outputItemWeights := make([]math.Int, len(outputItems))
	for i, item := range outputItems {
		transferFee := item.TransferFee[itemOutputsTransferFeePermutation[i]]
		weight := transferFee.Amount.Quo(minItemOutputsTransferFees.AmountOf(transferFee.Denom))
		outputItemWeights[i] = weight
	}

	// use the determined weights to calculate fees to be paid to cookbook owners and the network
	// item.TradePercentage is used to calculate the residual fee from the item sale
	// This fee gets clamped between minTransferFee and maxTransferFee
	maxTransferFee := k.MaxTransferFee(ctx)
	inputChainTotAmt := sdk.NewCoins()
	inputTransferTotAmt := sdk.NewCoins()
	inputCookbookOwnersTotAmtMap := make(map[string]sdk.Coins)
	coinOutputs := trade.CoinOutputs
	for i, item := range matchedInputItems {
		baseItemTransferFee := item.TransferFee[itemInputsTransferFeePermutation[i]]
		itemTransferFeeAmt := coinOutputs.AmountOf(baseItemTransferFee.Denom).Mul(inputItemWeights[i])
		tmpCookbookAmt := sdk.NewCoin(baseItemTransferFee.Denom, sdk.NewDecFromInt(itemTransferFeeAmt).Mul(item.TradePercentage).RoundInt())
		if tmpCookbookAmt.Amount.GT(maxTransferFee) {
			// clamp to maxTransferFee - maxTransferFee and minTransferFee are global (i.e. same for every coin)
			tmpCookbookAmt.Amount = maxTransferFee
		}
		chainAmt := sdk.NewCoin(baseItemTransferFee.Denom, tmpCookbookAmt.Amount.Mul(k.ItemTransferFeePercentage(ctx)))
		cookbookAmt := sdk.NewCoin(baseItemTransferFee.Denom, itemTransferFeeAmt.Sub(chainAmt.Amount))
		transferAmt := sdk.NewCoin(baseItemTransferFee.Denom, itemTransferFeeAmt.Sub(cookbookAmt.Amount).Sub(chainAmt.Amount))
		inputChainTotAmt = inputChainTotAmt.Add(chainAmt)
		inputTransferTotAmt = inputTransferTotAmt.Add(transferAmt)
		inputCookbookOwnersTotAmtMap[item.CookbookId] = inputCookbookOwnersTotAmtMap[item.CookbookId].Add(cookbookAmt)
	}
	outputChainTotAmt := sdk.NewCoins()
	outputTransferTotAmt := sdk.NewCoins()
	outputCookbookOwnersTotAmtMap := make(map[string]sdk.Coins)
	for i, item := range outputItems {
		baseItemTransferFee := item.TransferFee[itemOutputsTransferFeePermutation[i]]
		itemTransferFeeAmt := coinInputs.AmountOf(baseItemTransferFee.Denom).Mul(outputItemWeights[i])
		tmpCookbookAmt := sdk.NewCoin(baseItemTransferFee.Denom, sdk.NewDecFromInt(itemTransferFeeAmt).Mul(item.TradePercentage).RoundInt())
		if tmpCookbookAmt.Amount.GT(maxTransferFee) {
			// clamp to maxTransferFee - maxTransferFee and minTransferFee are global (i.e. same for every coin)
			tmpCookbookAmt.Amount = maxTransferFee
		}
		chainAmt := sdk.NewCoin(baseItemTransferFee.Denom, tmpCookbookAmt.Amount.Mul(k.ItemTransferFeePercentage(ctx)))
		cookbookAmt := sdk.NewCoin(baseItemTransferFee.Denom, itemTransferFeeAmt.Sub(chainAmt.Amount))
		transferAmt := sdk.NewCoin(baseItemTransferFee.Denom, itemTransferFeeAmt.Sub(cookbookAmt.Amount).Sub(chainAmt.Amount))
		outputChainTotAmt = outputChainTotAmt.Add(chainAmt)
		outputTransferTotAmt = outputTransferTotAmt.Add(transferAmt)
		outputCookbookOwnersTotAmtMap[item.CookbookId] = outputCookbookOwnersTotAmtMap[item.CookbookId].Add(cookbookAmt)
	}

	tradeCreatorAddr, _ := sdk.AccAddressFromBech32(trade.Creator)
	tradeFulfillerAddr, _ := sdk.AccAddressFromBech32(msg.Creator)
	// transfer ownership of items
	for _, item := range matchedInputItems {
		item.Owner = trade.Creator
		k.UpdateItem(ctx, item, tradeFulfillerAddr)
	}
	for _, item := range outputItems {
		item.Owner = msg.Creator
		k.UpdateItem(ctx, item, tradeCreatorAddr)
	}

	// send payments
	err = k.PayFees(ctx, tradeFulfillerAddr, inputChainTotAmt)
	if err != nil {
		return nil, err
	}
	err = k.bankKeeper.SendCoins(ctx, tradeFulfillerAddr, tradeCreatorAddr, inputTransferTotAmt)
	if err != nil {
		return nil, err
	}
	for cookbookID, amt := range inputCookbookOwnersTotAmtMap {
		cookbook, _ := k.GetCookbook(ctx, cookbookID)
		addr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
		err = k.bankKeeper.SendCoins(ctx, tradeFulfillerAddr, addr, amt)
		if err != nil {
			return nil, err
		}
	}

	err = k.PayFees(ctx, tradeCreatorAddr, outputChainTotAmt)
	if err != nil {
		return nil, err
	}
	err = k.bankKeeper.SendCoins(ctx, tradeCreatorAddr, tradeFulfillerAddr, outputTransferTotAmt)
	if err != nil {
		return nil, err
	}
	for cookbookID, amt := range outputCookbookOwnersTotAmtMap {
		cookbook, _ := k.GetCookbook(ctx, cookbookID)
		addr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
		err = k.bankKeeper.SendCoins(ctx, tradeCreatorAddr, addr, amt)
		if err != nil {
			return nil, err
		}
	}

	itemInputsRefs := make([]types.ItemRef, len(matchedInputItems))
	for i, item := range matchedInputItems {
		itemInputsRefs[i] = types.ItemRef{CookbookId: item.CookbookId, ItemId: item.Id}
	}
	err = ctx.EventManager().EmitTypedEvent(&types.EventFulfillTrade{
		Id:           trade.Id,
		Creator:      trade.Creator,
		Fulfiller:    msg.Creator,
		ItemInputs:   itemInputsRefs,
		CoinInputs:   coinInputs,
		ItemOutputs:  trade.ItemOutputs,
		CoinOutputs:  coinOutputs,
		PaymentInfos: msg.PaymentInfos,
	})

	telemetry.IncrCounter(1, "trade", "fulfill")

	return &types.MsgFulfillTradeResponse{}, err
}

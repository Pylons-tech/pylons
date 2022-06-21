package keeper

import (
	"context"
	"fmt"

	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateTrade(goCtx context.Context, msg *types.MsgCreateTrade) (*types.MsgCreateTradeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	items := make([]types.Item, 0)

	// coins with send_enable to false cannot be added to CoinOutputs
	err := k.bankKeeper.IsSendEnabledCoins(ctx, msg.CoinOutputs...)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	// coins with sendEnable to false cannot be added to CoinInputs unless they can be issued by a payment processor
	paymentProcessors := k.PaymentProcessors(ctx)
	for _, coinInput := range msg.CoinInputs {
		for _, coin := range coinInput.Coins {
			checkSendEnable := true
			for _, pp := range paymentProcessors {
				if coin.Denom == pp.CoinDenom {
					checkSendEnable = false
					break
				}
			}
			if checkSendEnable && !k.bankKeeper.IsSendEnabledCoin(ctx, coin) {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "coin %s cannot be traded", coin.Denom)
			}
		}
	}

	// check that each item provided for trade is owned by sender, and lock it
	for _, itemRef := range msg.ItemOutputs {
		item, found := k.GetItem(ctx, itemRef.CookbookId, itemRef.ItemId)
		if !found {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v not found", itemRef.ItemId, itemRef.CookbookId)
		}
		if item.Owner != msg.Creator {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v not owned", itemRef.ItemId, itemRef.CookbookId)
		}
		if !item.Tradeable {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v cannot be traded", itemRef.ItemId, itemRef.CookbookId)
		}
		k.LockItemForTrade(ctx, item)
		items = append(items, item)
	}
	if len(items) != 0 {
		for i, coinInputs := range msg.CoinInputs {
			_, err := types.FindValidPaymentsPermutation(items, coinInputs.Coins)
			if err != nil {
				return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "provided coinInputs at index %d cannot satisfy itemOutputs transferFees requirements", i)
			}
		}
	}
	// lock coins for trade
	err = k.LockCoinsForTrade(ctx, addr, msg.CoinOutputs)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	trade := types.Trade{
		Creator:     msg.Creator,
		CoinInputs:  msg.CoinInputs,
		ItemInputs:  msg.ItemInputs,
		CoinOutputs: msg.CoinOutputs,
		ItemOutputs: msg.ItemOutputs,
		ExtraInfo:   msg.ExtraInfo,
	}

	id := k.AppendTrade(
		ctx,
		trade,
	)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCreateTrade{
		Creator: msg.Creator,
		Id:      id,
	})

	telemetry.IncrCounter(1, "trade", "create")

	return &types.MsgCreateTradeResponse{
		Id: id,
	}, err
}

func (k msgServer) CancelTrade(goCtx context.Context, msg *types.MsgCancelTrade) (*types.MsgCancelTradeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if !k.HasTrade(ctx, msg.Id) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("key %d doesn't exist", msg.Id))
	}
	trade := k.GetTrade(ctx, msg.Id)
	if msg.Creator != trade.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	// unlock locked items
	for _, itemRef := range trade.ItemOutputs {
		// checks where passed at trade creation, we just need to unlock
		item, _ := k.GetItem(ctx, itemRef.CookbookId, itemRef.ItemId)
		k.UnlockItemForTrade(ctx, item, msg.Creator)
	}

	// unlock locked coins
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err := k.UnLockCoinsForTrade(ctx, addr, trade.CoinOutputs)
	if err != nil {
		// this should never happen, it means the module account has been drained of funds illegitimately
		panic(err)
	}

	k.RemoveTrade(ctx, msg.Id, addr)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCancelTrade{
		Creator: msg.Creator,
		Id:      msg.Id,
	})

	telemetry.IncrCounter(1, "trade", "cancel")

	return &types.MsgCancelTradeResponse{}, err
}

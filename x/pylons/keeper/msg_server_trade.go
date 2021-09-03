package keeper

import (
	"context"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateTrade(goCtx context.Context, msg *types.MsgCreateTrade) (*types.MsgCreateTradeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	minPayment := sdk.Coins{}
	items := make([]types.Item, 0)

	// check that each item provided for trade is owned by sender, and lock it
	for _, itemRef := range msg.ItemOutputs {
		item, found := k.GetItem(ctx, itemRef.CookbookID, itemRef.ItemID)
		if !found {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v not found", itemRef.ItemID, itemRef.CookbookID)
		}
		if item.Owner != msg.Creator {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v not owned", itemRef.ItemID, itemRef.CookbookID)
		}
		if !item.Tradeable {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v and cookbook id %v cannot be traded", itemRef.ItemID, itemRef.CookbookID)
		}
		k.LockItemForTrade(ctx, item)
		items = append(items, item)
	}
	_, err := types.FindValidPaymentsPermutation(items, msg.CoinInputs)
	if err != nil {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "provided coinInputs cannot satisfy itemOutputs transferFees requirements")
	}

	// lock coins for trade
	err = k.LockCoinsForTrade(ctx, addr, msg.CoinOutputs)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	// check that coinInputs are at least equal to the sum of all ItemOuputs transferFee
	if !msg.CoinInputs.IsAllGTE(minPayment) {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "coinInputs require minimum amount of %v to create this trade", minPayment.String())
	}

	var trade = types.Trade{
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
		Creator:   msg.Creator,
		ID:        id,
	})

	return &types.MsgCreateTradeResponse{
		ID: id,
	}, err
}

func (k msgServer) CancelTrade(goCtx context.Context, msg *types.MsgCancelTrade) (*types.MsgCancelTradeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	if !k.HasTrade(ctx, msg.ID) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("key %d doesn't exist", msg.ID))
	}
	trade := k.GetTrade(ctx, msg.ID)
	if msg.Creator != trade.Creator {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
	}

	// unlock locked items
	for _, itemRef := range trade.ItemOutputs {
		// checks where passed at trade creation, we just need to unlock
		item, _ := k.GetItem(ctx, itemRef.CookbookID, itemRef.ItemID)
		k.UnlockItemForTrade(ctx, item, msg.Creator)
	}

	// unlock locked coins
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	err := k.UnLockCoinsForTrade(ctx, addr, trade.CoinOutputs)
	if err != nil {
		// this should never happen, it means the module account has been drained of funds illegitimately
		panic(err)
	}

	k.RemoveTrade(ctx, msg.ID)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCancelTrade{
		Creator:   msg.Creator,
		ID:        msg.ID,
	})

	return &types.MsgCancelTradeResponse{}, err
}

package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/telemetry"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) SendItems(goCtx context.Context, msg *types.MsgSendItems) (*types.MsgSendItemsResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// STATEFUL CHECKS
	itemsByCookbook := make(map[string][]types.Item)
	items := make([]types.Item, 0)
	for _, itemRef := range msg.Items {
		// check it item exists and if it is owned by message creator
		item, found := k.Keeper.GetItem(ctx, itemRef.CookbookId, itemRef.ItemId)
		if !found {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item in cookbook %v with ID %v does not exist", itemRef.CookbookId, itemRef.ItemId)
		}

		// check if item is owned by msg.Creator if not ERROR
		if item.Owner != msg.Creator {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "Item in cookbook %v with ID %v not owned by sender", item.CookbookId, item.Id)
		}

		if !item.Tradeable {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "Item in cookbook %v with ID %v cannot be traded", item.CookbookId, item.Id)
		}

		itemsByCookbook[item.CookbookId] = append(itemsByCookbook[item.CookbookId], item)
		items = append(items, item)
	}

	transferFees := make(map[string]sdk.Coins)
	// get sender balance
	addr, _ := sdk.AccAddressFromBech32(msg.Creator)
	balance := k.bankKeeper.SpendableCoins(ctx, addr)
	permutation, err := types.FindValidPaymentsPermutation(items, balance)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	// change owner of items to receiver and re-set in store
	for idx, item := range items {
		item.Owner = msg.Receiver
		senderAddr, err := sdk.AccAddressFromBech32(msg.Creator)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "invalid sender address")
		}
		k.Keeper.UpdateItem(ctx, item, senderAddr)
		to, _ := k.GetUsernameByAddress(ctx, msg.Receiver)
		from, _ := k.GetUsernameByAddress(ctx, msg.Creator)
		history := item.NewItemHistory(ctx, to.Value, from.Value)
		k.SetItemHistory(ctx, history)
		transferFeeIdx := permutation[idx]
		transferFees[item.CookbookId] = transferFees[item.CookbookId].Add(item.TransferFee[transferFeeIdx])
	}

	// Calculate fee and pay it to cookbook owners and module account
	for cookbookID, cookbookTransferFees := range transferFees {
		var cookbookOwnerFees, modAccFees sdk.Coins
		cookbook, _ := k.GetCookbook(ctx, cookbookID)
		cookbookOwnerAddr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
		senderAddr, _ := sdk.AccAddressFromBech32(msg.Creator)
		// clamp transferFee between min and max allowed and separate amounts to be sent to payee and module account

		minTransferFee := k.MinTransferFee(ctx)
		maxTransferFee := k.MaxTransferFee(ctx)
		itemTransferFeePercentage := k.ItemTransferFeePercentage(ctx)

		for _, coin := range cookbookTransferFees {
			if coin.Amount.LT(minTransferFee) {
				coin.Amount = minTransferFee
			} else if coin.Amount.GT(maxTransferFee) {
				coin.Amount = maxTransferFee
			}
			// separate fees to account for percentage to be retained by module account
			modAccAmt := sdk.NewDecFromInt(coin.Amount).Mul(itemTransferFeePercentage).RoundInt()
			coin.Amount = coin.Amount.Sub(modAccAmt)
			cookbookOwnerFees = cookbookOwnerFees.Add(coin)
			coin.Amount = modAccAmt
			modAccFees = modAccFees.Add(coin)
		}

		err := k.bankKeeper.SendCoins(ctx, senderAddr, cookbookOwnerAddr, cookbookOwnerFees)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		err = k.PayFees(ctx, senderAddr, modAccFees)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventSendItems{
		Sender:   msg.Creator,
		Receiver: msg.Receiver,
		Items:    msg.Items,
	})

	telemetry.IncrCounter(float32(len(msg.Items)), "send_items", "send")

	return &types.MsgSendItemsResponse{}, err
}

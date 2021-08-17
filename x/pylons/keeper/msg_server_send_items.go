package keeper

import (
	"context"
	"fmt"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) SendItems(goCtx context.Context, msg *types.MsgSendItems) (*types.MsgSendItemsResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// STATEFUL CHECKS
	var items map[string]types.Item
	for _, itemID := range msg.ItemIDs {
		// check it item exists and if it is owned by message creator
		item, found := k.Keeper.GetItem(ctx, msg.CookbookID, itemID)
		if !found {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "item does not exist")
		}

		// check if item is owned by msg.Creator if not ERROR
		if item.Owner != msg.Creator {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("Item with ID %v not owned by account %v", itemID, msg.Creator))
		}

		items[itemID] = item
	}

	// Get item from keeper, change owner to receiver and re-set in store
	var transferFee sdk.Coins
	for _, item := range items {
		item.Owner = msg.Receiver
		k.Keeper.SetItem(ctx, item)
		transferFee.Add(item.TransferFee)
	}

	// Calculate fee and pay it to cookbook owner and module account
	var cookbookOwnerFees, modAccFees sdk.Coins
	cookbook, _ := k.GetCookbook(ctx, msg.CookbookID)
	cookbookOwnerAddr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
	senderAddr, _ := sdk.AccAddressFromBech32(msg.Creator)
	// clamp transferFee between min and max allowed and separate amounts to be sent to payee and module account
	minTransferFee := k.MinTransferFee(ctx)
	maxTransferFee := k.MaxTransferFee(ctx)
	itemTransferFeePercentage := k.ItemTransferFeePercentage(ctx)
	for _, coin := range transferFee {
		if coin.Amount.LT(minTransferFee) {
			coin.Amount = minTransferFee
		} else if coin.Amount.GT(maxTransferFee) {
			coin.Amount = maxTransferFee
		}
		// separate fees to account for percentage to be retained by module account
		modAccAmt := coin.Amount.ToDec().Mul(itemTransferFeePercentage).RoundInt()
		coin.Amount = coin.Amount.Sub(modAccAmt)
		cookbookOwnerFees.Add(coin)
		coin.Amount = modAccAmt
		modAccFees.Add(coin)
	}

	err := k.bankKeeper.SendCoins(ctx, senderAddr, cookbookOwnerAddr, cookbookOwnerFees)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	err = k.PayFees(ctx, senderAddr, modAccFees)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.MsgSendItemsResponse{}, nil
}

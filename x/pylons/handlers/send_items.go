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
)

// SendItems is used to send items between people
func (k msgServer) SendItems(ctx context.Context, msg *msgs.MsgSendItems) (*msgs.MsgSendItemsResponse, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	for _, val := range msg.ItemIDs {
		item, err := k.GetItem(sdkCtx, val)
		if err != nil {
			return nil, errInternal(err)
		}

		cookbook, err := k.GetCookbook(sdkCtx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("Invalid cookbook id"))
		}

		if item.Sender != msg.Sender {
			return nil, errInternal(errors.New("Item is not the sender's one"))
		}

		if err = item.NewTradeError(); err != nil {
			return nil, errInternal(err)
		}

		coins := types.NewPylon(item.CalculateTransferFee())

		if !keep.HasCoins(k.Keeper, sdkCtx, sender, coins) {
			return nil, errInternal(fmt.Errorf("Sender does not have enough coins for fees; %s", coins.String()))
		}

		item.Sender = msg.Receiver
		if err := k.SetItem(sdkCtx, item); err != nil {
			return nil, errInternal(fmt.Errorf("Error updating item inside keeper; %s", err.Error()))
		}

		err = ProcessSendItemsFee(sdkCtx, k.Keeper, sender, cookbook.Sender, coins)
		if err != nil {
			return nil, errInternal(fmt.Errorf("Error sending fees to send items; %s", err.Error()))
		}
	}

	return &msgs.MsgSendItemsResponse{
		Message: "successfully sent the items",
		Status:  "Success",
	}, nil
}

// ProcessSendItemsFee process send items fee
func ProcessSendItemsFee(ctx sdk.Context, keeper keep.Keeper, Sender sdk.AccAddress, CookbookOwner sdk.AccAddress, coins sdk.Coins) error {
	// send pylon amount to PylonsLLC, validator
	pylonAmount := coins.AmountOf(types.Pylon).Int64()

	if pylonAmount > 0 {
		pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			return err
		}

		err = keep.SendCoins(keeper, ctx, Sender, pylonsLLCAddress, types.NewPylon(pylonAmount))
		if err != nil {
			return err
		}

		cbOwnerProfitPercent := config.Config.Fee.ItemTransferCookbookOwnerProfitPercent
		cbOwnerProfit := pylonAmount * cbOwnerProfitPercent / 100
		if cbOwnerProfit > 0 {
			cbSenderCoins := types.NewPylon(cbOwnerProfit)
			err = keep.SendCoins(keeper, ctx, pylonsLLCAddress, CookbookOwner, cbSenderCoins)
			if err != nil {
				return err
			}
		}
	}
	return nil
}

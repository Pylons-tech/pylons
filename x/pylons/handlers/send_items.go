package handlers

import (
	"context"
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SendItems is used to send items between people
func (srv msgServer) SendItems(ctx context.Context, msg *types.MsgSendItems) (*types.MsgSendItemsResponse, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	for _, val := range msg.ItemIDs {
		item, err := srv.GetItem(sdkCtx, val)
		if err != nil {
			return nil, errInternal(err)
		}

		cookbook, err := srv.GetCookbook(sdkCtx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("invalid cookbook id"))
		}

		cookbookSender, err := sdk.AccAddressFromBech32(cookbook.Sender)
		if err != nil {
			return nil, errInternal(err)
		}

		if item.Sender != msg.Sender {
			return nil, errInternal(fmt.Errorf("item sender %s is not the same as msg sender %s", item.Sender, msg.Sender))
		}

		if err = item.NewTradeError(); err != nil {
			return nil, errInternal(err)
		}

		coins := types.NewPylon(item.CalculateTransferFee())

		if !keeper.HasCoins(srv.Keeper, sdkCtx, sender, coins) {
			return nil, errInternal(fmt.Errorf("sender does not have enough coins for fees: %s", coins.String()))
		}

		item.Sender = msg.Receiver
		if err := srv.SetItem(sdkCtx, item); err != nil {
			return nil, errInternal(fmt.Errorf("error updating item inside keeper: %w", err))
		}

		err = ProcessSendItemsFee(sdkCtx, srv.Keeper, sender, cookbookSender, coins)
		if err != nil {
			return nil, errInternal(fmt.Errorf("error sending fees to send items: %w", err))
		}
	}

	return &types.MsgSendItemsResponse{
		Message: "successfully sent the items",
		Status:  "Success",
	}, nil
}

// ProcessSendItemsFee process send items fee
func ProcessSendItemsFee(ctx sdk.Context, k keeper.Keeper, sender sdk.AccAddress, cookbookOwner sdk.AccAddress, coins sdk.Coins) error {
	// send pylon amount to PylonsLLC, validator
	pylonAmount := coins.AmountOf(types.Pylon).Int64()

	if pylonAmount > 0 {
		pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			return err
		}

		err = keeper.SendCoins(k, ctx, sender, pylonsLLCAddress, types.NewPylon(pylonAmount))
		if err != nil {
			return err
		}

		cbOwnerProfitPercent := config.Config.Fee.ItemTransferCookbookOwnerProfitPercent
		cbOwnerProfit := pylonAmount * cbOwnerProfitPercent / 100
		if cbOwnerProfit > 0 {
			cbSenderCoins := types.NewPylon(cbOwnerProfit)
			err = keeper.SendCoins(k, ctx, pylonsLLCAddress, cookbookOwner, cbSenderCoins)
			if err != nil {
				return err
			}
		}
	}
	return nil
}

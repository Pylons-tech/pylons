package handlers

import (
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SendItemsResponse is the response for fulfillRecipe
type SendItemsResponse struct {
	Message string
	Status  string
}

// HandlerMsgSendItems is used to send items between people
func HandlerMsgSendItems(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgSendItems) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	for _, val := range msg.ItemIDs {
		item, err := keeper.GetItem(ctx, val)
		if err != nil {
			return nil, errInternal(err)
		}

		cookbook, err := keeper.GetCookbook(ctx, item.CookbookID)
		if err != nil {
			return nil, errInternal(errors.New("Invalid cookbook id"))
		}

		if item.Sender.String() != msg.Sender.String() {
			return nil, errInternal(errors.New("Item is not the sender's one"))
		}

		if err = item.NewTradeError(); err != nil {
			return nil, errInternal(err)
		}

		item.Sender = msg.Receiver
		if err := keeper.SetItem(ctx, item); err != nil {
			return nil, errInternal(errors.New("Error updating item inside keeper"))
		}

		basicItemTransferFee := config.Config.Fee.BasicItemTransfer
		coins := sdk.Coins{
			sdk.NewCoin(types.Pylon, sdk.NewInt(basicItemTransferFee)),
		}

		err = ProcessSendItemsFee(ctx, keeper, msg.Sender, coins)
		if err != nil {
			return nil, errInternal(err)
		}

		additionalCoins := sdk.Coins{
			sdk.NewCoin(types.Pylon, sdk.NewInt(1717)),
		}

		err = ProcessSendItemsAdditionalFee(ctx, keeper, msg.Sender, cookbook.Sender, additionalCoins)
		if err != nil {
			return nil, errInternal(err)
		}
	}

	return marshalJSON(SendItemsResponse{
		Message: "successfully sent the items",
		Status:  "Success",
	})
}

// ProcessSendItemsFee process send items fee
func ProcessSendItemsFee(ctx sdk.Context, keeper keep.Keeper, Sender sdk.AccAddress, coins sdk.Coins) error {
	// send pylon amount to PylonsLLC, validator
	pylonAmount := coins.AmountOf(types.Pylon).Int64()
	if pylonAmount > 0 {
		pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
		if err != nil {
			return err
		}

		return keeper.CoinKeeper.SendCoins(ctx, Sender, pylonsLLCAddress, coins)
	}
	return nil
}

// ProcessSendItemsAdditionalFee process send items fee
func ProcessSendItemsAdditionalFee(ctx sdk.Context, keeper keep.Keeper, Sender sdk.AccAddress, Receiver sdk.AccAddress, coins sdk.Coins) error {
	// send pylon amount to PylonsLLC, validator
	pylonAmount := coins.AmountOf(types.Pylon).Int64()
	if pylonAmount > 0 {

		return keeper.CoinKeeper.SendCoins(ctx, Sender, Receiver, coins)
	}
	return nil
}

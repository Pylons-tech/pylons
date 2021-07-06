package handlers

import (
	"context"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// UpdateItemString is used to transact pylons between people
func (srv msgServer) UpdateItemString(ctx context.Context, msg *types.MsgUpdateItemString) (*types.MsgUpdateItemStringResponse, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)
	updateFee := types.NewPylon(config.Config.Fee.UpdateItemFieldString)

	if !keeper.HasCoins(srv.Keeper, sdkCtx, sender, updateFee) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Sender does not have enough coins for this action")
	}

	subErr := srv.CoinKeeper.SubtractCoins(sdkCtx, sender, updateFee)
	if subErr != nil {
		return nil, errInternal(subErr)
	}

	item, err := srv.GetItem(sdkCtx, msg.ItemID)
	if err != nil {
		return nil, errInternal(err)
	}

	if err = item.NewTradeError(); err != nil {
		return nil, errInternal(err)
	}

	keyID, ok := item.FindStringKey(msg.Field)
	if !ok {
		return nil, errInternal(errors.New("Provided field does not exist within the item"))
	}

	item.Strings[keyID].Value = msg.Value

	if err := srv.SetItem(sdkCtx, item); err != nil {
		return nil, errInternal(errors.New("Error updating item inside keeper"))
	}

	return &types.MsgUpdateItemStringResponse{
		Message: "successfully updated the item field",
		Status:  "Success",
	}, nil
}
